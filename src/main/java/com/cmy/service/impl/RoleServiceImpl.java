package com.cmy.service.impl;

import com.cmy.dao.RoleDao;
import com.cmy.entity.Role;
import com.cmy.service.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * Created by cmy on 2018/6/24.
 */
@Service("roleService")
public class RoleServiceImpl implements RoleService{

    @Autowired
    private RoleDao dao;

    @Override
    @Transactional(isolation = Isolation.READ_COMMITTED)
    public PageInfo<Role> getPage(int pageSize, int pageindex,Map<String,Object> maps) {
        //MyBatis的分页
        PageHelper.startPage(pageindex,pageSize);
        List<Role> lists=dao.getRoleList(maps);
        return new PageInfo<Role>(lists);
    }

    @Override
    @Transactional
    public void addRole(String RoleName, int isStart) {
        dao.addRole(RoleName,isStart);
    }

    @Override
    @Transactional(isolation = Isolation.READ_COMMITTED)
    public int getRoleCount(String roleName) {
        int result=dao.getRoleCount(roleName);
        return result;
    }

    @Override
    @Transactional(isolation = Isolation.READ_COMMITTED)
    public List<Integer> existsUser() {
        return dao.existsUser();
    }

    @Override
    @Transactional
    public void deleteRole(int[] ids) {
        dao.deleteRole(ids);
    }
}
