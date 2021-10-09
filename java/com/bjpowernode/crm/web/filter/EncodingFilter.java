package com.bjpowernode.crm.web.filter;

import javax.servlet.*;
import java.io.IOException;

public class EncodingFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
        System.out.println("进入到字符集编码的过滤器");
        req.setCharacterEncoding("utf-8");
        resp.setContentType("text/html;charset=utf-8");
        //将请求放行
        chain.doFilter(req,resp);
    }
    public void init(FilterConfig filterConfig) throws ServletException {

    }
    public void destroy() {

    }
}
