package com.yukimomo.user.service;

import com.yukimomo.user.dto.LoginDTO;
import com.yukimomo.user.dto.UserProfileUpdateDTO;
import com.yukimomo.user.vo.LoginVO;
import com.yukimomo.user.vo.UserInfoVO;
import com.yukimomo.user.vo.AvatarUploadVO;
import org.springframework.web.multipart.MultipartFile;

public interface UserAuthService {

    void sendLoginCode(String email);

    LoginVO loginByCode(LoginDTO dto);

    LoginVO refreshToken(String refreshToken);

    void logout(String refreshToken);

    UserInfoVO getCurrentUserInfo(Long userId);

    UserInfoVO updateProfile(Long userId, UserProfileUpdateDTO dto);

    AvatarUploadVO uploadAvatar(Long userId, MultipartFile file);
}
