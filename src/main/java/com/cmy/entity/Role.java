package com.cmy.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

public class Role{
	 /****/
	private Integer id;
	 /****/
	private String roleCode;
	 /****/
	private String roleName;
	 /****/
	private Date creationtime;
	 /****/
	private String createBy;
	 /****/
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	@JsonFormat(pattern="yyyy-MM-dd HH:mm:ss",timezone = "GMT+8")
	private Date lastUpdatetime;
	 /****/
	private Long isStart;
	

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public void setRoleCode(String roleCode){
		this.roleCode=roleCode;
	}

	public String getRoleCode(){
		return roleCode;
	}

	public void setRoleName(String roleName){
		this.roleName=roleName;
	}

	public String getRoleName(){
		return roleName;
	}

	public void setCreateBy(String createBy){
		this.createBy=createBy;
	}

	public String getCreateBy(){
		return createBy;
	}

	public Date getCreationtime() {
		return creationtime;
	}

	public void setCreationtime(Date creationtime) {
		this.creationtime = creationtime;
	}

	public Date getLastUpdatetime() {
		return lastUpdatetime;
	}

	public void setLastUpdatetime(Date lastUpdatetime) {
		this.lastUpdatetime = lastUpdatetime;
	}

	public void setIsStart(Long isStart){
		this.isStart=isStart;
	}

	public Long getIsStart(){
		return isStart;
	}
}

