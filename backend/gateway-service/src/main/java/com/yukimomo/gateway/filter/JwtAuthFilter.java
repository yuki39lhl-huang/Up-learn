package com.yukimomo.gateway.filter;

import cn.hutool.json.JSONUtil;
import com.yukimomo.common.constants.UlConstants;
import com.yukimomo.common.domain.Result;
import com.yukimomo.common.exception.ErrorCode;
import com.yukimomo.common.utils.JwtUtils;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.cloud.gateway.server.mvc.filter.FormFilter;
import org.springframework.core.Ordered;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * 网关 JWT 鉴权：校验 Access Token，透传 {@link UlConstants#USER_ID_HEADER}。
 */
@Component
@RequiredArgsConstructor
public class JwtAuthFilter implements Filter, Ordered {

    private static final List<String> WHITELIST = List.of(
            "/api/user/login/send-code",
            "/api/user/login",
            "/api/user/token/refresh",
            "/api/user/logout"
    );

    private final JwtUtils jwtUtils;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI();
        if (!path.startsWith("/api/") || isWhitelisted(path)) {
            chain.doFilter(request, response);
            return;
        }

        String auth = httpRequest.getHeader("Authorization");
        if (auth == null || !auth.startsWith("Bearer ")) {
            writeUnauthorized(httpResponse, ErrorCode.UNAUTHORIZED.getMessage());
            return;
        }

        String token = auth.substring(7).trim();
        if (token.isEmpty()) {
            writeUnauthorized(httpResponse, ErrorCode.UNAUTHORIZED.getMessage());
            return;
        }

        try {
            Long userId = jwtUtils.getUserId(token);
            HeaderMapRequestWrapper wrapped = new HeaderMapRequestWrapper(httpRequest);
            wrapped.addHeader(UlConstants.USER_ID_HEADER, String.valueOf(userId));
            chain.doFilter(wrapped, response);
        } catch (Exception ex) {
            writeUnauthorized(httpResponse, ErrorCode.UNAUTHORIZED.getMessage());
        }
    }

    private boolean isWhitelisted(String path) {
        for (String allowed : WHITELIST) {
            if (path.equals(allowed) || path.startsWith(allowed + "/")) {
                return true;
            }
        }
        return false;
    }

    private void writeUnauthorized(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        Result<Void> body = Result.error(ErrorCode.UNAUTHORIZED.getCode(), message);
        response.getWriter().write(JSONUtil.toJsonStr(body));
    }

    @Override
    public int getOrder() {
        return FormFilter.FORM_FILTER_ORDER - 1;
    }
}
