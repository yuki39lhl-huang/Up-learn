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
            "/api/user/logout",
            "/api/user/forgot-password",
            "/api/school",
            "/api/major",
            "/api/exam-subjects",
            "/api/syllabus"
    );

    /** 仅 GET 公开（避免 POST 发帖等被放行） */
    private static final List<String> GET_ONLY_WHITELIST = List.of(
            "/api/community/posts",
            "/api/community/users",
            "/api/user/briefs",
            "/api/user/public"
    );

    private final JwtUtils jwtUtils;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI();
        String method = httpRequest.getMethod();
        if (!path.startsWith("/api/")) {
            chain.doFilter(request, response);
            return;
        }
        if (isWhitelisted(path, method)) {
            // 公开读也尽量解析 Token，便于「已赞/已关注」等个性化字段
            chain.doFilter(tryAttachUser(httpRequest), response);
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

    private ServletRequest tryAttachUser(HttpServletRequest httpRequest) {
        String auth = httpRequest.getHeader("Authorization");
        if (auth == null || !auth.startsWith("Bearer ")) {
            return httpRequest;
        }
        String token = auth.substring(7).trim();
        if (token.isEmpty()) {
            return httpRequest;
        }
        try {
            Long userId = jwtUtils.getUserId(token);
            HeaderMapRequestWrapper wrapped = new HeaderMapRequestWrapper(httpRequest);
            wrapped.addHeader(UlConstants.USER_ID_HEADER, String.valueOf(userId));
            return wrapped;
        } catch (Exception ignored) {
            return httpRequest;
        }
    }

    private boolean isWhitelisted(String path, String method) {
        for (String allowed : WHITELIST) {
            if (path.equals(allowed) || path.startsWith(allowed + "/")) {
                return true;
            }
        }
        if ("GET".equalsIgnoreCase(method)) {
            for (String allowed : GET_ONLY_WHITELIST) {
                if (path.equals(allowed) || path.startsWith(allowed + "/")) {
                    return true;
                }
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
