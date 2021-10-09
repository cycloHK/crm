package com.bjpowernode.crm.workbench.web.controller;

import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.settings.service.impl.UserServiceImpl;
import com.bjpowernode.crm.utils.*;
import com.bjpowernode.crm.vo.PaginationVo;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;
import com.bjpowernode.crm.workbench.service.impl.ActivityServiceImpl;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath(); //可以拿到urlpattern (web.xml中的)
        System.out.println("进入市场活动控制器 path ==" + path);

        if ("/workbench/activity/getUserList.do".equals(path)){
            //判断是哪个功能然后执行
            getUserList(request,response);

        }else if("/workbench/activity/save.do".equals(path)){
            System.out.println("进入save功能");
            save(request,response);
        }else if("/workbench/activity/pageList.do".equals(path)){
            System.out.println("进入pageList功能");
            pageList(request,response);
        }
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("进入到controller的pageList");
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String pageNoStr = request.getParameter("pageNo");
        String pageSizeStr = request.getParameter("pageSize");

        //分页操作
        int pageNo = Integer.valueOf(pageNoStr);
           //每页展示的记录数
        int pageSize = Integer.valueOf(pageSizeStr);
        int skipCount = (pageNo - 1) * pageSize;

        Map<String,Object> map = new HashMap<String, Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("skipCount",skipCount);
        map.put("pageSize",pageSize);

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());
        //建立一个vo视图 int total List<Activity> dataList;
        PaginationVo<Activity> vo = as.pageList(map);
        //System.out.println("controller pagelist 回来map" + map);
        PrintJson.printJsonObj(response,vo);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        System.out.println("执行市场活动的添加操作");

        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description = request.getParameter("description");
        String createTime = DateTimeUtil.getSysTime(); //创建时间为现在系统时间
        String createBy = ((User)request.getSession().getAttribute("user")).getName(); //创建人为当前的用户

        Activity at = new Activity();
        at.setId(id);
        at.setCost(cost);
        at.setSTartDate(startDate);
        at.setOwner(owner);
        at.setName(name);
        at.setEndDate(endDate);
        at.setDescription(description);
        at.setCreateTime(createTime);
        at.setCreateBy(createBy);

        ActivityService as = (ActivityService) ServiceFactory.getService(new ActivityServiceImpl());

        boolean flag =as.save(at);
        System.out.println("falge ======" + flag);

        PrintJson.printJsonFlag(response,flag);
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {
        //System.out.println("controller 市场活动 获取用户信息 getUserList");
        //调用用户业务实现类
        UserService us = (UserService) ServiceFactory.getService(new UserServiceImpl());
        List<User> uList = us.getUserList();
       // System.out.println("controller 市场活动 获取用户信息 getUserList 回来成功 " + uList);
        PrintJson.printJsonObj(response,uList);

    }

}
