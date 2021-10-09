package com.bjpowernode.crm.settings.service.impl;

import com.bjpowernode.crm.exception.LoginException;
import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.settings.service.UserService;
import com.bjpowernode.crm.utils.DateTimeUtil;
import com.bjpowernode.crm.utils.SqlSessionUtil;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImpl implements UserService {

    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);
    //登录业务
    public User login(String loginAct, String loginPwd, String ip) throws LoginException {
        //业务层先进入dao层 查看账号密码
        Map<String,String> map = new HashMap<String, String >();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);

        User user = userDao.login(map);      //dao查询数据 去写dao
        System.out.println("uuuuuuuuuuu"+user);
        if (user==null){
            System.out.println("user ! = null");
            throw new LoginException("账号密码错误");
        }
        //验证其他信息

//        //验证失效时间
        String expireTime = user.getExpireTime();
        String currentTime = DateTimeUtil.getSysTime();
        if (expireTime.compareTo(currentTime)<0){
            throw new LoginException("账号已失效");
        }
        //判断锁定状态
        String lockState = user.getLockState();
        if("0".equals(lockState)){
            throw new LoginException("账号已锁定");
        }
        //判断ip地址
        String allowIps = user.getAllowIps();
//        if (!allowIps.contains(ip)){
//            throw new LoginException("ip地址受限");
//        }
        return user;
    }
    //获取用户信息业务
    public List<User> getUserList() {
        System.out.println("imple开始调用dao");
        List<User> uList = userDao.getUserList();
        System.out.println("dao返回数据"+uList);
        return uList;
    }
}
