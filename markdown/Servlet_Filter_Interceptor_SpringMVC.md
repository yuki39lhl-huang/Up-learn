# Servlet、Tomcat、Filter、Interceptor 与 Spring MVC

## 一、Servlet 是什么？

可以先把 **Servlet** 理解成：

> Java Web 中用来接收 HTTP 请求、处理请求并返回 HTTP 响应的一套规范。

它是学习 **Spring MVC、Spring Boot Web、Filter、Interceptor** 时非常重要的底层概念。

---

## 二、Servlet 的基本工作方式

最早写 Java Web 的时候，可以直接编写一个 Servlet：

```java
public class UserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response) {

        // 处理请求
    }
}
```

浏览器访问：

```text
GET /user/1
```

服务器会找到对应的 Servlet，然后执行它：

```text
浏览器
  ↓
Tomcat
  ↓
UserServlet
  ↓
返回 HTTP 响应
```

---

## 三、Tomcat 和 Servlet 的关系

这是非常容易混淆的一点：

> **Servlet 是规范，Tomcat 是实现。**

可以简单类比：

```text
Servlet
  ↓
相当于“规则 / 接口”

Tomcat
  ↓
相当于“实现这个规则的服务器”
```

Tomcat 负责：

- 接收 HTTP 请求
- 创建 `HttpServletRequest`
- 创建 `HttpServletResponse`
- 找到应该执行的 Servlet
- 调用 Servlet
- 把响应返回给客户端

所以启动 Spring Boot Web 项目时，经常会看到：

```text
Tomcat started on port 8080
```

这说明你的 Spring Boot Web 应用通常运行在 **Tomcat Servlet 容器**中。

---

## 四、Spring MVC 是什么？

传统 Java Web 的大致流程：

```text
浏览器
  ↓
Tomcat
  ↓
Servlet
  ↓
业务代码
```

使用 Spring MVC 后，流程变成：

```text
浏览器
  ↓
Tomcat
  ↓
Filter
  ↓
DispatcherServlet
  ↓
Interceptor
  ↓
Controller
  ↓
Service
  ↓
Mapper
  ↓
数据库
```

其中：

> **DispatcherServlet 是 Spring MVC 的核心 Servlet。**

它负责接收请求，并将请求交给正确的 Controller。

---

## 五、DispatcherServlet 是什么？

例如有一个 Controller：

```java
@GetMapping("/users/{id}")
public User getUser(@PathVariable Long id) {
    return userService.getById(id);
}
```

当浏览器访问：

```text
GET /users/1
```

并不是 Tomcat 直接找到 `getUser()` 方法。

而是：

```text
Tomcat
  ↓
DispatcherServlet
  ↓
Spring MVC
  ↓
找到对应的 Controller
  ↓
getUser()
```

所以可以简单理解：

> **DispatcherServlet 是 Spring MVC 的总入口。**

---

## 六、Filter 和 Interceptor 的区别

前面提到的 Filter 和 Interceptor，可以放到整个请求链路中理解。

### Filter

Filter 属于 **Servlet 规范**，工作在 Servlet 容器这一层。

它可以在请求进入 Servlet 前进行处理，也可以在 Servlet 执行完成后进行处理。

例如：

```text
浏览器
  ↓
Filter
  ↓
DispatcherServlet
```

### Interceptor

Interceptor 属于 **Spring MVC**。

只有请求进入 `DispatcherServlet`，进入 Spring MVC 之后，Interceptor 才会参与处理。

---

## 七、Filter 和 Interceptor 谁先执行？

一般情况下：

> **Filter 先执行，Interceptor 后执行。**

完整请求链路：

```text
客户端请求
   ↓
Filter
   ↓
DispatcherServlet
   ↓
Interceptor.preHandle()
   ↓
Controller
   ↓
Interceptor.postHandle()
   ↓
Interceptor.afterCompletion()
   ↓
Filter
   ↓
响应客户端
```

因此可以记住：

> **Filter → DispatcherServlet → Interceptor → Controller**

---

## 八、为什么 Filter 比 Interceptor 先执行？

原因是两者所处的层级不同。

### Filter

Filter 属于：

```text
Servlet 容器层
```

Tomcat 处理请求时，就可以先经过 Filter。

### Interceptor

Interceptor 属于：

```text
Spring MVC 层
```

必须等请求进入 `DispatcherServlet`，Spring MVC 开始处理请求之后，Interceptor 才能执行。

所以：

```text
Tomcat / Servlet 容器
        ↓
      Filter
        ↓
DispatcherServlet
        ↓
Spring MVC
        ↓
   Interceptor
        ↓
    Controller
```

---

## 九、几个概念放在一起理解

建议按照下面这个层级记忆：

```text
Tomcat
  └── Servlet 容器
       ├── Filter
       │
       └── DispatcherServlet
            └── Spring MVC
                 ├── Interceptor
                 └── Controller
                      └── Service
                           └── Mapper
                                └── MySQL
```

---

## 十、最终记忆

### Servlet

> Java Web 中处理 HTTP 请求和响应的规范。

### Tomcat

> Servlet 容器，可以运行 Servlet，是 Servlet 规范的常见实现。

### DispatcherServlet

> Spring MVC 的核心 Servlet，负责接收请求并找到对应的 Controller。

### Filter

> Servlet 层面的过滤器，通常比 Interceptor 更早执行。

### Interceptor

> Spring MVC 层面的拦截器，在 DispatcherServlet 内部执行。

### Controller

> 真正处理业务 HTTP 接口的地方。

---

## 十一、最重要的一张图

```text
                    HTTP 请求
                       │
                       ▼
                    Tomcat
                       │
                       ▼
                    Filter
                       │
                       ▼
              DispatcherServlet
                       │
                       ▼
                 Spring MVC
                       │
                       ▼
                  Interceptor
                       │
                       ▼
                  Controller
                       │
                       ▼
                    Service
                       │
                       ▼
                    Mapper
                       │
                       ▼
                    MySQL
                       │
                       ▼
                  HTTP 响应
```

一句话总结：

> **Tomcat 负责承载 Servlet，DispatcherServlet 是 Spring MVC 的核心 Servlet；Filter 属于 Servlet 层，Interceptor 属于 Spring MVC 层，所以通常是 Filter 先执行，再进入 Interceptor。**
