package com.bjpowernode.crm.workbench.service.impl;

import com.bjpowernode.crm.utils.SqlSessionUtil;
import com.bjpowernode.crm.vo.PaginationVo;
import com.bjpowernode.crm.workbench.dao.ActivityDao;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.service.ActivityService;

import java.util.List;
import java.util.Map;

public class ActivityServiceImpl implements ActivityService {
    private ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);

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
}
