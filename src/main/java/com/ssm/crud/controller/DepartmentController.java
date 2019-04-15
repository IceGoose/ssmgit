package com.ssm.crud.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.ssm.crud.bean.Department;
import com.ssm.crud.bean.Msg;
import com.ssm.crud.service.Departmentservice;

@Controller
public class DepartmentController {

	@Autowired
	Departmentservice deptService;
	
	/**
	 * 获取所有部门的信息
	 */
	@RequestMapping("depts")
	@ResponseBody
	public Msg getDepts(){
		List<Department> list = deptService.getAll();
		return Msg.success().add("depts", list);
	}
}
