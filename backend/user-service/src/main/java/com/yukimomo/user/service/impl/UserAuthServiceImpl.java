package com.yukimomo.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.common.utils.JwtUtils;
import com.yukimomo.common.utils.PasswordUtils;
import com.yukimomo.user.constant.UserConstants;
import com.yukimomo.user.dto.LoginDTO;
import com.yukimomo.user.dto.UserProfileUpdateDTO;
import com.yukimomo.user.entity.User;
import com.yukimomo.user.mapper.UserMapper;
import com.yukimomo.user.service.LoginCodeService;
import com.yukimomo.user.service.OssService;
import com.yukimomo.user.service.RefreshTokenService;
import com.yukimomo.user.service.UserAuthService;
import com.yukimomo.user.vo.AvatarUploadVO;
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
import java.util.Set;

@Service
@RequiredArgsConstructor
public class UserAuthServiceImpl implements UserAuthService {

    private final UserMapper userMapper;
    private final LoginCodeService loginCodeService;
    private final RefreshTokenService refreshTokenService;
    private final JwtUtils jwtUtils;
    private final OssService ossService;

    private static final long MAX_AVATAR_BYTES = 2 * 1024 * 1024L;
    private static final Set<String> ALLOWED_AVATAR_TYPES = Set.of(
            "image/jpeg", "image/png", "image/webp");

    //发送登录验证码
    @Override
    public void sendLoginCode(String email) {
        loginCodeService.sendCode(email);
    }

    //邮箱验证码登录
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
    @Transactional(rollbackFor = Exception.class)
    public UserInfoVO updateProfile(Long userId, UserProfileUpdateDTO dto) {
        if (StrUtil.isBlank(dto.getNickname()) && StrUtil.isBlank(dto.getAvatarUrl())) {
            throw new BizException(ErrorCode.BAD_REQUEST, "请至少修改昵称或头像");
        }
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BizException(ErrorCode.USER_NOT_FOUND);
        }
        if (StrUtil.isNotBlank(dto.getNickname())) {
            String nickname = dto.getNickname().trim();
            if (nickname.length() < 1 || nickname.length() > 32) {
                throw new BizException(ErrorCode.NICKNAME_INVALID);
            }
            user.setNickname(nickname);
        }
        if (StrUtil.isNotBlank(dto.getAvatarUrl())) {
            String avatarUrl = dto.getAvatarUrl().trim();
            if (!isValidAvatarUrl(avatarUrl)) {
                throw new BizException(ErrorCode.AVATAR_URL_INVALID);
            }
            user.setAvatarUrl(avatarUrl);
        }
        userMapper.updateById(user);
        return toUserInfoVO(user);
    }

    @Override
    public AvatarUploadVO uploadAvatar(Long userId, MultipartFile file) {
        if (file == null || file.isEmpty()) {
            throw new BizException(ErrorCode.BAD_REQUEST, "请选择图片文件");
        }
        String contentType = file.getContentType();
        if (contentType == null || !ALLOWED_AVATAR_TYPES.contains(contentType.toLowerCase(Locale.ROOT))) {
            throw new BizException(ErrorCode.AVATAR_FILE_INVALID);
        }
        if (file.getSize() > MAX_AVATAR_BYTES) {
            throw new BizException(ErrorCode.AVATAR_FILE_INVALID);
        }
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BizException(ErrorCode.USER_NOT_FOUND);
        }
        String ext = extensionForContentType(contentType);
        String avatarUrl;
        try {
            avatarUrl = ossService.uploadAvatar(userId, ext, file.getInputStream(), file.getSize());
        } catch (IOException e) {
            throw new BizException(ErrorCode.INTERNAL_ERROR, "头像上传失败");
        }
        user.setAvatarUrl(avatarUrl);
        userMapper.updateById(user);
        AvatarUploadVO vo = new AvatarUploadVO();
        vo.setAvatarUrl(ossService.toDisplayUrl(user.getAvatarUrl()));
        return vo;
    }

    private UserInfoVO toUserInfoVO(User user) {
        UserInfoVO vo = new UserInfoVO();
        vo.setUserId(user.getId());
        vo.setEmail(user.getEmail());
        vo.setNickname(user.getNickname());
        vo.setAvatarUrl(ossService.toDisplayUrl(user.getAvatarUrl()));
        return vo;
    }

    private boolean isValidAvatarUrl(String url) {
        if (url.length() > 512) {
            return false;
        }
        String lower = url.toLowerCase(Locale.ROOT);
        return lower.startsWith("https://") || lower.startsWith("http://");
    }

    private String extensionForContentType(String contentType) {
        switch (contentType.toLowerCase(Locale.ROOT)) {
            case "image/png":
                return ".png";
            case "image/webp":
                return ".webp";
            default:
                return ".jpg";
        }
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
        return vo;
    }

    private User registerByEmail(String email) {
        User user = new User();
        user.setEmail(email);
        user.setNickname(UserConstants.NICKNAME_PREFIX + RandomUtil.randomString(6));
        user.setAvatarUrl(UserConstants.DEFAULT_AVATAR_PREFIX + email);
        user.setPasswordHash(PasswordUtils.encode(RandomUtil.randomString(32)));
        userMapper.insert(user);
        return user;
    }

    private String normalizeEmail(String email) {
        return email.trim().toLowerCase(Locale.ROOT);
    }
}
