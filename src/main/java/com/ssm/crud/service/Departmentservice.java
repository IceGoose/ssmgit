package com.ssm.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssm.crud.bean.Department;
import com.ssm.crud.dao.DepartmentMapper;

@Service
public class Departmentservice {

	@Autowired
	DepartmentMapper deptMapper;
	
	public List<Department> getAll() {
		List<Department> list = deptMapper.selectByExample(null);
		return list;
	}

}
