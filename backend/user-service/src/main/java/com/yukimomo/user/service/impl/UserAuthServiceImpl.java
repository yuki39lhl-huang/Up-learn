package com.yukimomo.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.common.utils.JwtUtils;
import com.yukimomo.common.utils.PasswordUtils;
import com.yukimomo.user.constant.UserConstants;
import com.yukimomo.user.dto.ChangePasswordDTO;
import com.yukimomo.user.dto.LoginDTO;
import com.yukimomo.user.dto.PasswordLoginDTO;
import com.yukimomo.user.dto.ResetPasswordDTO;
import com.yukimomo.user.dto.UserProfileUpdateDTO;
import com.yukimomo.user.entity.User;
import com.yukimomo.user.mapper.UserMapper;
import com.yukimomo.user.service.LoginCodeService;
import com.yukimomo.user.service.OssService;
import com.yukimomo.user.service.RefreshTokenService;
import com.yukimomo.user.service.UserAuthService;
import com.yukimomo.user.service.UserExamPreferenceService;
import com.yukimomo.user.service.UserTargetService;
import com.yukimomo.api.user.vo.UserExamPreferenceVO;
import com.yukimomo.api.user.vo.UserPublicProfileVO;
import com.yukimomo.api.user.vo.UserTargetVO;
import com.yukimomo.user.util.ImageUploadSupport;
import com.yukimomo.user.vo.AvatarUploadVO;
import com.yukimomo.user.vo.CommunityImageUploadVO;
import com.yukimomo.user.vo.LoginVO;
import com.yukimomo.user.vo.UserInfoVO;
import cn.hutool.core.util.RandomUtil;
import cn.hutool.core.util.StrUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Locale;
import java.util.Objects;
import java.util.regex.Pattern;

/**
 * 用户认证实现：验证码/密码登录、双 Token、资料与 OSS 头像、设密与邮箱重置。
 * <p>
 * 密码写入统一走 {@link #applyPasswordHash}（BCrypt + {@code password_set=1}）。
 * 注册时写入随机哈希占位且 {@code password_set=0}，避免空哈希，且不能用该占位做密码登录。
 */
@Service
@RequiredArgsConstructor
public class UserAuthServiceImpl implements UserAuthService {

    private final UserMapper userMapper;
    private final LoginCodeService loginCodeService;
    private final RefreshTokenService refreshTokenService;
    private final JwtUtils jwtUtils;
    private final OssService ossService;
    private final UserExamPreferenceService examPreferenceService;
    private final UserTargetService userTargetService;

    private static final long MAX_AVATAR_BYTES = 2 * 1024 * 1024L;
    /** 8～32 位，至少各含一个字母与一个数字 */
    private static final Pattern PASSWORD_PATTERN =
            Pattern.compile("^(?=.*[A-Za-z])(?=.*\\d).{8,32}$");

    @Override
    public void sendLoginCode(String email) {
        loginCodeService.sendCode(email);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public LoginVO loginByCode(LoginDTO dto) {
        String email = normalizeEmail(dto.getEmail());
        loginCodeService.verifyAndConsume(email, dto.getCode());

        User user = userMapper.selectOne(new LambdaQueryWrapper<User>()
                .eq(User::getEmail, email));

        boolean newUser = false;
        if (user == null) {
            user = registerByEmail(email);
            newUser = true;
        }

        return buildLoginVO(user, newUser);
    }

    @Override
    @Transactional(readOnly = true)
    public LoginVO loginByPassword(PasswordLoginDTO dto) {
        String email = normalizeEmail(dto.getEmail());
        User user = userMapper.selectOne(new LambdaQueryWrapper<User>()
                .eq(User::getEmail, email));
        if (user == null) {
            throw new BizException(ErrorCode.USER_NOT_FOUND);
        }
        if (!isPasswordSet(user)) {
            throw new BizException(ErrorCode.PASSWORD_NOT_SET);
        }
        if (!PasswordUtils.matches(dto.getPassword(), user.getPasswordHash())) {
            throw new BizException(ErrorCode.PASSWORD_MISMATCH);
        }
        return buildLoginVO(user, false);
    }

    @Override
    @Transactional(readOnly = true)
    public LoginVO refreshToken(String refreshToken) {
        RefreshTokenService.RefreshSession session = refreshTokenService.validate(refreshToken);
        User user = userMapper.selectById(session.userId());
        if (user == null) {
            refreshTokenService.revoke(refreshToken);
            throw new BizException(ErrorCode.REFRESH_TOKEN_INVALID);
        }
        String newRefresh = refreshTokenService.rotate(refreshToken, user.getId(), user.getEmail());
        return buildLoginVO(user, false, newRefresh);
    }

    @Override
    public void logout(String refreshToken) {
        refreshTokenService.revoke(refreshToken);
    }

    @Override
    public UserInfoVO getCurrentUserInfo(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BizException(ErrorCode.USER_NOT_FOUND);
        }
        return toUserInfoVO(user);
    }

    @Override
    public java.util.List<com.yukimomo.api.user.vo.UserBriefVO> listBriefs(java.util.List<Long> ids) {
        if (ids == null || ids.isEmpty()) {
            return java.util.List.of();
        }
        java.util.List<Long> distinct = ids.stream().filter(java.util.Objects::nonNull).distinct().limit(100).toList();
        if (distinct.isEmpty()) {
            return java.util.List.of();
        }
        java.util.List<User> users = userMapper.selectBatchIds(distinct);
        java.util.List<com.yukimomo.api.user.vo.UserBriefVO> list = new java.util.ArrayList<>();
        for (User user : users) {
            com.yukimomo.api.user.vo.UserBriefVO brief = new com.yukimomo.api.user.vo.UserBriefVO();
            brief.setUserId(user.getId());
            brief.setNickname(user.getNickname());
            brief.setAvatarUrl(ossService.toDisplayUrl(user.getAvatarUrl()));
            list.add(brief);
        }
        return list;
    }

    @Override
    public UserPublicProfileVO getPublicProfile(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BizException(ErrorCode.USER_NOT_FOUND);
        }
        UserPublicProfileVO vo = new UserPublicProfileVO();
        vo.setUserId(user.getId());
        vo.setNickname(user.getNickname());
        vo.setAvatarUrl(ossService.toDisplayUrl(user.getAvatarUrl()));
        vo.setBio(user.getBio());
        vo.setShowFollowList(user.getShowFollowList() == null || user.getShowFollowList() == 1);
        try {
            UserExamPreferenceVO pref = examPreferenceService.get(userId);
            if (pref != null) {
                vo.setProvince(pref.getProvince());
                vo.setMajorCategory(pref.getMajorCategory());
            }
        } catch (Exception ignored) {
            // 未设备考偏好时不展示
        }
        try {
            java.util.List<UserTargetVO> targets = userTargetService.list(userId);
            if (targets != null && !targets.isEmpty()) {
                vo.setTargetSchools(targets.stream()
                        .map(t -> {
                            if (t == null || StrUtil.isBlank(t.getSchoolName())) {
                                return null;
                            }
                            if (StrUtil.isNotBlank(t.getMajorName())) {
                                return t.getSchoolName().trim() + " · " + t.getMajorName().trim();
                            }
                            return t.getSchoolName().trim();
                        })
                        .filter(Objects::nonNull)
                        .distinct()
                        .limit(6)
                        .toList());
            }
        } catch (Exception ignored) {
            // 未设目标院校时不展示
        }
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public UserInfoVO updateProfile(Long userId, UserProfileUpdateDTO dto) {
        boolean hasNickname = StrUtil.isNotBlank(dto.getNickname());
        boolean hasAvatar = StrUtil.isNotBlank(dto.getAvatarUrl());
        boolean hasBio = dto.getBio() != null;
        boolean hasShowFollow = dto.getShowFollowList() != null;
        if (!hasNickname && !hasAvatar && !hasBio && !hasShowFollow) {
            throw new BizException(ErrorCode.BAD_REQUEST, "请至少修改一项资料");
        }
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BizException(ErrorCode.USER_NOT_FOUND);
        }
        if (hasNickname) {
            String nickname = dto.getNickname().trim();
            if (nickname.length() < 1 || nickname.length() > 32) {
                throw new BizException(ErrorCode.NICKNAME_INVALID);
            }
            user.setNickname(nickname);
        }
        if (hasAvatar) {
            String avatarUrl = dto.getAvatarUrl().trim();
            if (!isValidAvatarUrl(avatarUrl)) {
                throw new BizException(ErrorCode.AVATAR_URL_INVALID);
            }
            user.setAvatarUrl(avatarUrl);
        }
        if (hasBio) {
            String bio = dto.getBio().trim();
            if (bio.length() > 200) {
                throw new BizException(ErrorCode.BAD_REQUEST, "简介不能超过 200 个字符");
            }
            user.setBio(bio.isEmpty() ? null : bio);
        }
        if (hasShowFollow) {
            user.setShowFollowList(Boolean.TRUE.equals(dto.getShowFollowList()) ? 1 : 0);
        }
        // not-null 策略下清空 bio 需显式 set
        LambdaUpdateWrapper<User> uw = new LambdaUpdateWrapper<User>().eq(User::getId, userId);
        if (hasNickname) {
            uw.set(User::getNickname, user.getNickname());
        }
        if (hasAvatar) {
            uw.set(User::getAvatarUrl, user.getAvatarUrl());
        }
        if (hasBio) {
            uw.set(User::getBio, user.getBio());
        }
        if (hasShowFollow) {
            uw.set(User::getShowFollowList, user.getShowFollowList());
        }
        userMapper.update(null, uw);
        return toUserInfoVO(userMapper.selectById(userId));
    }

    @Override
    public AvatarUploadVO uploadAvatar(Long userId, MultipartFile file) {
        String contentType = ImageUploadSupport.validateImage(file, MAX_AVATAR_BYTES, ErrorCode.AVATAR_FILE_INVALID);
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BizException(ErrorCode.USER_NOT_FOUND);
        }
        String ext = ImageUploadSupport.extensionForContentType(contentType);
        String avatarUrl;
        try {
            avatarUrl = ossService.uploadAvatar(userId, ext, file.getInputStream());
        } catch (IOException e) {
            throw new BizException(ErrorCode.INTERNAL_ERROR, "头像上传失败");
        }
        user.setAvatarUrl(avatarUrl);
        userMapper.updateById(user);
        AvatarUploadVO vo = new AvatarUploadVO();
        vo.setAvatarUrl(ossService.toDisplayUrl(user.getAvatarUrl()));
        return vo;
    }

    @Override
    public CommunityImageUploadVO uploadCommunityImage(Long userId, MultipartFile file) {
        String contentType = ImageUploadSupport.validateImage(file, MAX_AVATAR_BYTES, ErrorCode.AVATAR_FILE_INVALID);
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BizException(ErrorCode.USER_NOT_FOUND);
        }
        String ext = ImageUploadSupport.extensionForContentType(contentType);
        String url;
        try {
            url = ossService.uploadCommunityImage(userId, ext, file.getInputStream(), contentType);
        } catch (IOException e) {
            throw new BizException(ErrorCode.INTERNAL_ERROR, "配图上传失败");
        }
        CommunityImageUploadVO vo = new CommunityImageUploadVO();
        vo.setUrl(url);
        return vo;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void changePassword(Long userId, ChangePasswordDTO dto) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BizException(ErrorCode.USER_NOT_FOUND);
        }
        String newPassword = StrUtil.trim(dto.getNewPassword());
        validatePasswordStrength(newPassword);

        boolean alreadySet = isPasswordSet(user);
        if (alreadySet) {
            String oldPassword = StrUtil.trim(dto.getOldPassword());
            if (StrUtil.isBlank(oldPassword)) {
                throw new BizException(ErrorCode.OLD_PASSWORD_REQUIRED);
            }
            if (!PasswordUtils.matches(oldPassword, user.getPasswordHash())) {
                throw new BizException(ErrorCode.PASSWORD_MISMATCH);
            }
        }

        // 显式 UPDATE，避免 updateById 在部分场景漏更 password_hash / password_set
        applyPasswordHash(userId, newPassword, "密码更新失败，请重试");
    }

    @Override
    public void sendForgotPasswordCode(String email) {
        String normalized = normalizeEmail(email);
        User user = userMapper.selectOne(new LambdaQueryWrapper<User>()
                .eq(User::getEmail, normalized));
        if (user == null) {
            throw new BizException(ErrorCode.USER_NOT_FOUND);
        }
        loginCodeService.sendResetCode(normalized);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void resetPassword(ResetPasswordDTO dto) {
        String email = normalizeEmail(dto.getEmail());
        String newPassword = StrUtil.trim(dto.getNewPassword());
        validatePasswordStrength(newPassword);
        loginCodeService.verifyAndConsumeResetCode(email, dto.getCode());
        User user = userMapper.selectOne(new LambdaQueryWrapper<User>()
                .eq(User::getEmail, email));
        if (user == null) {
            throw new BizException(ErrorCode.USER_NOT_FOUND);
        }
        applyPasswordHash(user.getId(), newPassword, "密码重置失败，请重试");
    }

    /** 覆盖写入密码哈希并标记已设密 */
    private void applyPasswordHash(Long userId, String rawPassword, String failMessage) {
        int rows = userMapper.update(
                null,
                new LambdaUpdateWrapper<User>()
                        .eq(User::getId, userId)
                        .set(User::getPasswordHash, PasswordUtils.encode(rawPassword))
                        .set(User::getPasswordSet, 1));
        if (rows != 1) {
            throw new BizException(ErrorCode.INTERNAL_ERROR, failMessage);
        }
    }

    private void validatePasswordStrength(String password) {
        if (password == null || !PASSWORD_PATTERN.matcher(password).matches()) {
            throw new BizException(ErrorCode.PASSWORD_WEAK);
        }
    }

    private boolean isPasswordSet(User user) {
        return user.getPasswordSet() != null && user.getPasswordSet() == 1;
    }

    private UserInfoVO toUserInfoVO(User user) {
        UserInfoVO vo = new UserInfoVO();
        vo.setUserId(user.getId());
        vo.setEmail(user.getEmail());
        vo.setNickname(user.getNickname());
        vo.setAvatarUrl(ossService.toDisplayUrl(user.getAvatarUrl()));
        vo.setBio(user.getBio());
        vo.setShowFollowList(user.getShowFollowList() == null || user.getShowFollowList() == 1);
        vo.setHasPassword(isPasswordSet(user));
        return vo;
    }

    private boolean isValidAvatarUrl(String url) {
        if (url.length() > 512) {
            return false;
        }
        String lower = url.toLowerCase(Locale.ROOT);
        return lower.startsWith("https://") || lower.startsWith("http://");
    }

    private LoginVO buildLoginVO(User user, boolean newUser) {
        String refreshToken = refreshTokenService.create(user.getId(), user.getEmail());
        return buildLoginVO(user, newUser, refreshToken);
    }

    private LoginVO buildLoginVO(User user, boolean newUser, String refreshToken) {
        String accessToken = jwtUtils.createAccessToken(user.getId(), user.getEmail());
        LoginVO vo = new LoginVO();
        vo.setAccessToken(accessToken);
        vo.setRefreshToken(refreshToken);
        vo.setAccessExpiresIn(jwtUtils.getAccessExpiresInSeconds());
        vo.setNewUser(newUser);
        vo.setUserId(user.getId());
        vo.setEmail(user.getEmail());
        vo.setNickname(user.getNickname());
        vo.setAvatarUrl(ossService.toDisplayUrl(user.getAvatarUrl()));
        vo.setHasPassword(isPasswordSet(user));
        return vo;
    }

    private User registerByEmail(String email) {
        User user = new User();
        user.setEmail(email);
        user.setNickname(UserConstants.NICKNAME_PREFIX + RandomUtil.randomString(6));
        user.setAvatarUrl(UserConstants.DEFAULT_AVATAR_PREFIX + email);
        user.setPasswordHash(PasswordUtils.encode(RandomUtil.randomString(32)));
        user.setPasswordSet(0);
        userMapper.insert(user);
        return user;
    }

    private String normalizeEmail(String email) {
        return email.trim().toLowerCase(Locale.ROOT);
    }
}
