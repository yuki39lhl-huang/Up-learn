package com.yukimomo.user.service;

import com.yukimomo.user.config.UlLoginProperties;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.mail.autoconfigure.MailProperties;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.util.HtmlUtils;

import java.nio.charset.StandardCharsets;

/**
 * 验证码投递：开发模式打日志，否则经 QQ SMTP 发 HTML 邮件（发件人显示 up-learn + OSS logo）。
 * MQ 消费者与同步降级共用此逻辑。
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LoginCodeMailSender {

    private static final String FROM_PERSONAL = "up-learn";

    private final UlLoginProperties loginProperties;
    private final JavaMailSender mailSender;
    private final MailProperties mailProperties;

    public void dispatch(String email, String code, String scene) {
        if (loginProperties.isDevLogCode()) {
            log.info("【开发模式】邮箱 {} {}验证码: {}（{} 秒内有效）",
                    email, scene, code, loginProperties.getCodeTtlSeconds());
            return;
        }
        if (!isMailConfigured()) {
            log.warn("未配置 spring.mail.username/password，无法发送验证码邮件（收件人={}）", email);
            return;
        }
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            // multipart=false：无内嵌附件，避免邮箱列表出现 inline 标记
            MimeMessageHelper helper = new MimeMessageHelper(
                    mimeMessage, false, StandardCharsets.UTF_8.name());
            helper.setFrom(new InternetAddress(mailProperties.getUsername(), FROM_PERSONAL, StandardCharsets.UTF_8.name()));
            helper.setTo(email);
            helper.setSubject("[up-learn] · " + scene + "验证码");
            helper.setText(buildHtml(code, scene), true);
            mailSender.send(mimeMessage);
            log.info("验证码邮件已发送：邮箱={} 场景={}", email, scene);
        } catch (Exception e) {
            log.warn("验证码邮件发送失败：邮箱={} 场景={} 原因={}", email, scene, e.getMessage());
        }
    }

    private boolean isMailConfigured() {
        return StringUtils.hasText(mailProperties.getUsername())
                && StringUtils.hasText(mailProperties.getPassword());
    }

    private String buildHtml(String code, String scene) {
        int ttl = loginProperties.getCodeTtlSeconds();
        String ttlLabel = ttl >= 60 && ttl % 60 == 0
                ? (ttl / 60) + " 分钟"
                : ttl + " 秒";
        String title = "验证 up-learn " + scene + "邮箱";
        String logoUrl = StringUtils.hasText(loginProperties.getMailLogoUrl())
                ? loginProperties.getMailLogoUrl().trim()
                : "";
        String logoBlock = StringUtils.hasText(logoUrl)
                ? """
                      <tr>
                        <td align="center" style="padding:40px 24px 24px;">
                          <img src="%s" width="56" height="56" alt="up-learn" style="display:block;border:0;border-radius:12px;">
                        </td>
                      </tr>
                      """.formatted(HtmlUtils.htmlEscape(logoUrl))
                : """
                      <tr>
                        <td align="center" style="padding:40px 24px 8px;">
                          <p style="margin:0;font-size:18px;font-weight:600;color:#1d1d1f;">up-learn</p>
                        </td>
                      </tr>
                      """;
        return """
                <!DOCTYPE html>
                <html lang="zh-CN">
                <head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"></head>
                <body style="margin:0;padding:0;background:#ffffff;font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif;color:#1d1d1f;">
                  <table role="presentation" width="100%%" cellspacing="0" cellpadding="0" style="background:#ffffff;">
                    %s
                    <tr>
                      <td align="center" style="padding:8px 24px 0;">
                        <h1 style="margin:0;font-size:24px;line-height:1.35;font-weight:600;color:#1d1d1f;">%s</h1>
                      </td>
                    </tr>
                    <tr>
                      <td align="center" style="padding:20px 32px 0;max-width:520px;">
                        <p style="margin:0;font-size:15px;line-height:1.6;color:#6e6e73;max-width:440px;">
                          此邮箱正用于 up-learn「%s」验证。请在页面中输入以下验证码：
                        </p>
                      </td>
                    </tr>
                    <tr>
                      <td align="center" style="padding:28px 24px 8px;">
                        <p style="margin:0;font-size:36px;letter-spacing:6px;font-weight:700;color:#1d1d1f;font-family:ui-monospace,SFMono-Regular,Menlo,Consolas,monospace;">%s</p>
                      </td>
                    </tr>
                    <tr>
                      <td align="center" style="padding:0 24px 32px;">
                        <p style="margin:0;font-size:13px;color:#86868b;">验证码将在发送后 %s 失效。</p>
                      </td>
                    </tr>
                    <tr>
                      <td align="center" style="padding:0 32px 40px;">
                        <p style="margin:0;font-size:12px;line-height:1.7;color:#86868b;max-width:440px;text-align:left;">
                          <strong style="color:#6e6e73;">你收到此电子邮件的原因：</strong><br>
                          有人正在使用该邮箱进行 up-learn %s。若非本人操作，可忽略本邮件，验证码不会被他人用于登录。
                        </p>
                      </td>
                    </tr>
                    <tr>
                      <td align="center" style="padding:16px 24px 32px;border-top:1px solid #f5f5f7;">
                        <p style="margin:0;font-size:12px;color:#aeaeb2;">up-learn · 招生查询与刷题平台</p>
                      </td>
                    </tr>
                  </table>
                </body>
                </html>
                """.formatted(logoBlock, title, scene, code, ttlLabel, scene);
    }
}
