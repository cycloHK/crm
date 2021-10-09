package com.bjpowernode.crm.web.filter;

import com.bjpowernode.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        System.out.println("进入到验证有没有登录过的过滤器");
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;

        String path = request.getServletPath();
        //不拦截的资源,自动放行
        if ("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)) {

            chain.doFilter(req,resp);

            //其他资源一律拦截
        }else {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            //如果user不为空，说明登陆过
            if (user!=null){
                System.out.println("放行");
                chain.doFilter(req,resp);
            }else{
                response.sendRedirect(request.getContextPath()+"/login.jsp");
            }
        }
    }

    public void destroy() {

    }
}
