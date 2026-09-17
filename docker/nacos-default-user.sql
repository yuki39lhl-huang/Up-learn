-- default nacos console user (password: nacos)
INSERT IGNORE INTO users (username, password, enabled) VALUES ('nacos', '$2a$10$EuWPZHzz32dSoykTpl6j/OPIg.Y51svGBnJn/SO91QKK0UqObVUW6', TRUE);
INSERT IGNORE INTO roles (username, role) VALUES ('nacos', 'ROLE_ADMIN');
