package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.settings.dao.UserDao;
import com.bjpowernode.crm.settings.domain.User;
import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.vo.PaginationVo;
import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.dao.ActivityRemarkDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    private ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

    public boolean save(Activity at) {
        //System.out.println("SaveImpl保存数据开始");
        boolean flag = true;
        int count = activityDao.save(at);
        //System.out.println("count=====" + count);
        if (count!=1){
            flag = false;
        }
        return flag;
    }

    public PaginationVo<Activity> pageList(Map<String, Object> map) {
        //取得total 取得List
        int total = activityDao.getTotalByCondition(map);
        //System.out.println("SaveImp取得total" + total);
        List<Activity>dataList = activityDao.getActivityListByCondition(map);
        //封装进入vo
        PaginationVo<Activity> vo = new PaginationVo<Activity>();
        vo.setTotal(total);
        vo.setDataList(dataList);
        return vo;
    }

    public boolean delete(String[] ids) {
        boolean flag = true;

        //查询出需要删除的备注的数量
        int count1 = activityRemarkDao.getCountByAids(ids);

        //删除备注，返回收到影响的条数（实际删除的条数）
        int count2 = activityRemarkDao.deleteByAids(ids);

        if (count1!=count2){
            System.out.println("条数不一 count1!=count2");
            flag = false;
        }

        //删除市场活动
        int count3 = activityDao.delete(ids);
        if (count3!= ids.length){
            System.out.println("条数不一 count1!=count2");
            flag = false;
        }
        return flag;
    }

    public Map<String, Object> getUserListAndActivity(String id) {
        //取ulist
        List<User> uList =  userDao.getUserList();
        Activity a = activityDao.getById(id);
        //将ulist和a打包都map中
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("uList",uList);
        map.put("a",a);
        //返回
        return map;
    }

    public boolean update(Activity at) {
        boolean flag = true;
        int count = activityDao.update(at);
        if(count != 1){
            flag = false;
        }
        return flag;
    }
}
