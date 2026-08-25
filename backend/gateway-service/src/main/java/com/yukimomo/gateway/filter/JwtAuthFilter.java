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
 * 网关 JWT 鉴权过滤器
 * 网关 JWT 鉴权：校验 Access Token，透传 {@link UlConstants#USER_ID_HEADER}。
 */
@Component
@RequiredArgsConstructor
public class JwtAuthFilter implements Filter, Ordered {

    //白名单,调用of方法快速创建不可变列表
    private static final List<String> WHITELIST = List.of(
            "/api/user/login/send-code",
            "/api/user/login",
            "/api/user/token/refresh",
            "/api/user/logout",
            // 院校公开查询（基线：院校接口无需 Token）
            "/api/school",
            "/api/major"
    );

    //JwtUtils工具类,用于解析access JWT token
    private final JwtUtils jwtUtils;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        //将ServletRequest转换为HttpServletRequest和HttpServletResponse
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        //获取请求路径,若路径是/api/开头且不在白名单中,则进行JWT鉴权
        String path = httpRequest.getRequestURI();
        //true|false = true 放行, false|false = 不进if继续执行下面的代码
        if (!path.startsWith("/api/") || isWhitelisted(path)) {
            chain.doFilter(request, response);
            return;
        }

        //从Authorization(accesstokenjwt)获取token,前端会对token添加类型前缀Bearer
        String auth = httpRequest.getHeader("Authorization");
        //如果token为空或者不是以Bearer开头,则返回401错误
        if (auth == null || !auth.startsWith("Bearer ")) {
            writeUnauthorized(httpResponse, ErrorCode.UNAUTHORIZED.getMessage());
            return;
        }

        //subString切割Bearer后面的token,从第7个字符开始,截取到末尾,并去除空格
        String token = auth.substring(7).trim();
        if (token.isEmpty()) {
            writeUnauthorized(httpResponse, ErrorCode.UNAUTHORIZED.getMessage());
            return;
        }

        try {
            Long userId = jwtUtils.getUserId(token);//获取userId
            HeaderMapRequestWrapper wrapped = new HeaderMapRequestWrapper(httpRequest);
            wrapped.addHeader(UlConstants.USER_ID_HEADER, String.valueOf(userId));//将userId添加到请求头中
            chain.doFilter(wrapped, response);//继续执行过滤器
        } catch (Exception ex) {
            writeUnauthorized(httpResponse, ErrorCode.UNAUTHORIZED.getMessage());//写入401错误
        }
    }

    //判断路径是否在白名单中
    private boolean isWhitelisted(String path) {
        for (String allowed : WHITELIST) {
            //path和allowed完全匹配,或者path是allowed的子路径,返回true
            if (path.equals(allowed) || path.startsWith(allowed + "/")) {
                return true;
            }
        }
        return false;
    }

    private void writeUnauthorized(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);//设置状态码为401
        response.setCharacterEncoding(StandardCharsets.UTF_8.name());//设置字符编码为UTF-8
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);//设置内容类型为JSON
        Result<Void> body = Result.error(ErrorCode.UNAUTHORIZED.getCode(), message);//创建错误结果
        response.getWriter().write(JSONUtil.toJsonStr(body));//将错误结果写入响应体
    }

    @Override
    public int getOrder() {
        return FormFilter.FORM_FILTER_ORDER - 1;
    }
}
