package com.yukimomo.user.service;

import com.yukimomo.user.dto.LoginDTO;
import com.yukimomo.user.vo.LoginVO;
import com.yukimomo.user.vo.UserInfoVO;

public interface UserAuthService {

    void sendLoginCode(String email);

    LoginVO loginByCode(LoginDTO dto);

    LoginVO refreshToken(String refreshToken);

    void logout(String refreshToken);

    UserInfoVO getCurrentUserInfo(Long userId);
}
