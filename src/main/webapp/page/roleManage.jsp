<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户管理</title>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/themes/default/easyui.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/themes/icon.css">
<script type="text/javascript"
	src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/jquery.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript">
	function searchUser() {
		$("#dg").datagrid('load', {
			"roleName" : $("#s_id").val(),
			"isStart":$("[name='isStart']").val()
		});
	}
	
	function deleteRole() {
		//获取了所有datagrid选中的行
		var selectRows = $("#dg").datagrid("getSelections");
		if (selectRows.length == 0) {
			$.messager.alert("系统提示", "请选择要删除的数据！");
			return;
		}
		//strIds 保存都是Role的id
		var strIds = [];
		for (var i = 0; i < selectRows.length; i++) {
			strIds[i]=selectRows[i].id;
		}
		
        var deleteIds=[];

		$.messager
				.confirm(
						"系统提示",
						"您确定要删除这<font color=red>" + selectRows.length
								+ "</font>条数据吗?",
						function(r) {
						    //使用sql语句检索存在用户的角色编号
							$.post("${pageContext.request.contextPath}/role/existsUser",function (data) {
                                   deleteIds=sub(strIds,data);//获取差集
								   var notIds=arrayIntersection(strIds,data).join(",")//获取交集
								   $.messager.alert(
                                    "系统提示",
                                    "角色编号为"+notIds+"不能删除！");
                                   var ids=deleteIds.join(",");
                                   if(ids!=""){
                                       $.post("/role/deleteRole",
                                           {
                                               ids : ids
                                           },
                                           function(result) {
                                               if (result) {
                                                   $.messager.alert(
                                                       "系统提示",
                                                       "数据已经成功删除！");
                                                   $("#dg").datagrid(
                                                       "reload");
                                               } else {
                                                   $.messager
                                                       .alert("系统提示",
                                                           "数据删除失败，请联系管理员！");
                                               }
                                           }, "json");
								   }else{
                                       $.messager.alert(
                                           "系统提示",
                                           "您选择删除的角色下都存在用户 不能删除！");
                                           return;
								   }
                            })

						});
	}

	function openUserAddDiglog() {
		$("#dlg").dialog("open").dialog("setTitle", "添加用户信息");
		$("#flag").val(1);
		$("#id").attr("readonly", false);
	}

	function openUserModifyDiglog() {
		//easy ui 中的获取datagrid中一行数据或某几行数据的操作是:
			 
		var selectRows = $("#dg").datagrid("getSelections"); //获取所有选中的数据
		if (selectRows.length != 1) {
			$.messager.alert("系统提示", "请选择一条要编辑的数据！");
			return;
		}
		//选中的第一行数据
		var row = selectRows[0];
		
		//打开修改页面的
		$("#dlg").dialog("open").dialog("setTitle", "编辑用户信息");

		$("#fm").form("load",row);
		
		var c=$("[name='startIs']");
		
		if(row.isStart==1){
			c.attr("value",row.isStart);
			c.attr("checked","checked");
		}
		//如果为修改操作 flag元素的值为2
		$("#flag").val(2);
	}

	function checkData() {
		if ($("#roleName").val() == '') {
			$.messager.alert("系统系统", "请输入角色名");
			$("#roleName").focus();
			return;
		}
		var flag = $("#flag").val();
		if (flag == 1) {
			$.post("${pageContext.request.contextPath}/role/existsRole",
					{
						roleName : $("#roleName").val(),
					}, function(result) {
						if (result) {
							$.messager.alert("系统系统", "该用户名已存在，请更换下！");
							$("#id").focus();
						} else {
							saveUser();
						}
					}, "json");
		} else {
			//修改角色操作
			updateRole();
		}
	}
	function saveUser(){
		$("#fm").form("submit", {
			url : '${pageContext.request.contextPath}/role/addRole',
			onSubmit : function() {
				return $(this).form("validate");
			},
			success : function(result) {
				var result = eval('(' + result + ')');
				if (result) {
					$.messager.alert("系统", "添加成功！");
					//关闭修改窗口
					$("#dlg").dialog("close");
					//刷新datagrid
					$("#dg").datagrid("reload");
				} else {
					$.messager.alert("系统系统", "添加失败！");
					return;
				}
			}
		});
	}

	function updateRole() {
		$("#fm").form("submit", {
			url : '${pageContext.request.contextPath}/role/motifyRole',
			onSubmit : function() {
				return $(this).form("validate");
			},
			success : function(result) {
				var result = eval('(' + result + ')');
				if (result) {
					$.messager.alert("系统", "修改成功！");
					//关闭修改窗口
					$("#dlg").dialog("close");
					//刷新datagrid
					$("#dg").datagrid("reload");
				} else {
					$.messager.alert("系统系统", "保存失败！");
					return;
				}
			}
		});
	}
	function resetValue() {
		$("#id").val("");
		$("#password").val("");
		$("#firstName").val("");
		$("#lastName").val("");
		$("#email").val("");
	}

	function closeUserDialog() {
		$("#dlg").dialog("close");
		resetValue();
	}

	function formatStatus(val, row) {
           if(val=="1"){
        	   return '<input type="checkbox" checked="checked"/>';
           }else{
        	   return '<input type="checkbox"/>';
           }
	}
	function downloadRole() {
		location.href="${pageContext.request.contextPath}/role/downloadRole"
	}

	//取数组之间的差集
    function sub(a, b) {
        var arr3 = new Array();
        for (var i = 0; i < a.length; i++) {
            var flag = true;
            for (var j = 0; j < b.length; j++) {
                if (a[i] == b[j])
                    flag = false;
            }
            if (flag)
                arr3.push(a[i]);
        }
        return arr3
    }

    //获取数组的交集
    function arrayIntersection(a, b) {
        var ai = 0, bi = 0;
        var result = new Array();
        while (ai < a.length && bi < b.length) {
            if (a[ai] < b[bi]) {
                ai++;
            } else if (a[ai] > b[bi]) {
                bi++;
            } else /* they're equal */
            {
                result.push(a[ai]);
                ai++;
                bi++;
            }
        }
        return result;
    }
	
</script>
</head>
<body style="margin: 1px">
	<table id="dg" title="角色管理" class="easyui-datagrid" fitColumns="true"
		pagination="true"
		url="${pageContext.request.contextPath}/role/getPage" fit="true"
		toolbar="#tb">
		<thead>
			<tr>
				<th field="cb" checkbox="true" align="center"></th>
				<th field="id" align="center">角色编号</th>
				<th field="roleName" width="80" align="center">角色名称</th>
				<th field="createBy" width="80" align="center">创建人</th>
				<th field="lastUpdatetime" width="50" align="center">更新时间</th>
				<th field="isStart" width="50" align="center"
					formatter="formatStatus">状态</th>
			</tr>
		</thead>
	</table>
	<div id="tb">
		<div>
		    <a href="javascript:downloadRole()" class="easyui-linkbutton"  iconCls="icon-add" plain="true">下载报表</a>
			 <a href="javascript:openUserAddDiglog()" class="easyui-linkbutton"  iconCls="icon-add" plain="true">添加</a>
			 <a href="javascript:openUserModifyDiglog()" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
			 <a href="javascript:deleteRole()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
		</div>
			<div>
				&nbsp;用户名:&nbsp;<input type="text" id="s_id" size="20"
					onkeydown="if(event.keyCode==13) searchUser()" name="roleName" /> 
					
			    &nbsp;状态:&nbsp;
				<select id="cc" class="easyui-combobox" name="isStart" style="width:50px;">
					<option value="1">启用</option>
					<option value="0">禁用</option>
				</select> <a href="javascript:searchUser()" class="easyui-linkbutton"
					iconCls="icon-search" plain="true"> 搜索</a>
			</div>
	</div>

	<div id="dlg-buttons">
		<a href="javascript:checkData()" class="easyui-linkbutton"
			iconCls="icon-ok">保存</a> <a href="javascript:closeUserDialog()"
			class="easyui-linkbutton" iconCls="icon-cancel">关闭</a>
	</div>

	<div id="dlg" class="easyui-dialog"
		style="width: 620px; height: 280px; padding: 10px 20px" closed="true"
		buttons="#dlg-buttons">

		<form id="fm" method="post">
			<table cellpadding="8px">
				<tr>
					<td>角色的名称:</td>
					<td><input type="hidden" id="id" name="id" /> <input
						type="text" id="roleName" name="roleName"
						class="easyui-validatebox" required="true" /></td>
				</tr>
				<tr>
					<td>是否启用:</td>
					<td>
						<!-- 把这个复选框取消选中:禁用 0 value(拿不到)
 				                           复选框选中:启用   value
 				     --> <input type="checkbox" name="startIs" /> <input
						type="hidden" id="flag">
					</td>
				</tr>
			</table>
		</form>

	</div>
</body>
</html>