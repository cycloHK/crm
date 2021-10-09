package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int save(Activity at);

    List<Activity> getActivityListByCondition(Map<String, Object> map);

    int getTotalByCondition(Map<String, Object> map);

    int delete(String[] ids);
}