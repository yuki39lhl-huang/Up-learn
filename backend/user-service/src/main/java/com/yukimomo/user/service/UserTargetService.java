package com.yukimomo.user.service;

import com.yukimomo.user.dto.AddUserTargetDTO;
import com.yukimomo.user.vo.UserTargetVO;

import java.util.List;

/**
 * 用户目标院校服务。
 */
public interface UserTargetService {

    List<UserTargetVO> list(Long userId);

    UserTargetVO add(Long userId, AddUserTargetDTO dto);

    void remove(Long userId, Long id);
}
