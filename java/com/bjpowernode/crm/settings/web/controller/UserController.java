package com.bjpowernode.crm.settings.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.*;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("进入用户控制器");
        String path = request.getServletPath(); //可以拿到urlpattern (web.xml中的)
        if ("/settings/user/login.do".equals(path)){
            //判断是哪个功能然后执行
            login(request,response);

        }else if("/settings/user/save.do".equals(path)){
           // save(request,response);
        }
    }


    private void login(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到了controller的登录验证操作");
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        loginPwd = MD5Util.getMD5(loginPwd);
        //接收浏览器端的ip地址
        String ip = request.getRemoteAddr();


        System.out.println("进入到了controller的登录验证操作123");
        //使用数据库 创建service形态 事务操作
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());

        System.out.println("进入到了controller的登录验证操作123456");

        try{
        System.out.println("进入到了controller的登录验证操作123789");
            User user = us.login(loginAct,loginPwd,ip);   //传递账号密码ip到service 返回user对象存入session域
            System.out.println("controller user 回来了" + user);
            request.getSession().setAttribute("user",user);
            PrintJson.printJsonFlag(response,true);  //传回ajax请求data 一个true
        }catch (Exception e){
            e.printStackTrace();
            String msg = e.getMessage();
            Map<String,Object> map = new HashMap<String, Object>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);  //传回ajax错误信息和false 用map存储的
        }
    }
}
