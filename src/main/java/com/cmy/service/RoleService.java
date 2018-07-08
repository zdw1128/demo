package com.cmy.service;

import com.cmy.entity.Role;
import com.github.pagehelper.PageInfo;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * Created by cmy on 2018/6/24.
 */
public interface RoleService {
    PageInfo<Role> getPage(int pageSize,int pageindex,Map<String,Object> maps);
    void addRole(String RoleName, int isStart);
    int getRoleCount(String roleName);
    List<Integer> existsUser();
    void deleteRole(int[] ids);

}
