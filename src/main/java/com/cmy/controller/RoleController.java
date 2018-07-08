package com.cmy.controller;

import com.cmy.entity.Role;
import com.cmy.service.RoleService;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by cmy on 2018/6/24.
 */
@Controller
@RequestMapping("role")
public class RoleController {

    @Resource(name="roleService")
    private RoleService service;

    @RequestMapping("getPage")
    @ResponseBody
    public Object getPage(HttpServletRequest request,String rows,String page){
        String roleName=request.getParameter("roleName");
        int isStart=request.getParameter("isStart")==null?-1:Integer.parseInt(request.getParameter("isStart"));
        int pageindex=page==null?1:Integer.parseInt(page);

        Map<String,Object> maps=new HashMap<String,Object>();

        maps.put("roleName",roleName);

        maps.put("isStart",isStart);

        PageInfo<Role> pages=service.getPage(Integer.parseInt(rows),pageindex,maps);

        return pages.getList();
    }
    @RequestMapping("addRole")
    @ResponseBody
    public Object addRole(String roleName,String startIs){
        int isStart=startIs==null?0:1;
        service.addRole(roleName,isStart);
        return true;
    }

    @RequestMapping("existsRole")
    @ResponseBody
    public Object existsRole(String roleName){
        int result=service.getRoleCount(roleName);
        if(result>0)
            return true;
        return false;
    }

    @RequestMapping("existsUser")
    @ResponseBody
    public Object existsUser(){
        return service.existsUser();
    }


    @RequestMapping("deleteRole")
    @ResponseBody
    public Object deleteRole(@RequestParam("ids") int[] ids){
        service.deleteRole(ids);
        return true;
    }


}
