package com.cmy.dao;

import com.cmy.entity.Role;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * Created by cmy on 2018/6/24.
 */
public interface RoleDao {
     List<Role> getRoleList(Map<String,Object> maps);
     void addRole(@Param("roleName")String RoleName,@Param("isStart") int isStart);
     int getRoleCount(String roleName);
     List<Integer> existsUser(); //获取存在用户的角色编号
     void deleteRole(int[] ids);
}
