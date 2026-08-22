package com.yukimomo.user.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.yukimomo.common.exception.BizException;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.common.utils.JwtUtils;
import com.yukimomo.common.utils.PasswordUtils;
import com.yukimomo.user.constant.UserConstants;
import com.yukimomo.user.dto.LoginDTO;
import com.yukimomo.user.entity.User;
import com.yukimomo.user.mapper.UserMapper;
import com.yukimomo.user.service.LoginCodeService;
import com.yukimomo.user.service.RefreshTokenService;
import com.yukimomo.user.service.UserAuthService;
import com.yukimomo.user.vo.LoginVO;
import com.yukimomo.user.vo.UserInfoVO;
import cn.hutool.core.util.RandomUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Locale;

@Service
@RequiredArgsConstructor
public class UserAuthServiceImpl implements UserAuthService {

    private final UserMapper userMapper;
    private final LoginCodeService loginCodeService;
    private final RefreshTokenService refreshTokenService;
    private final JwtUtils jwtUtils;

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
        UserInfoVO vo = new UserInfoVO();
        vo.setUserId(user.getId());
        vo.setEmail(user.getEmail());
        vo.setNickname(user.getNickname());
        vo.setAvatarUrl(user.getAvatarUrl());
        return vo;
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
        vo.setAvatarUrl(user.getAvatarUrl());
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
