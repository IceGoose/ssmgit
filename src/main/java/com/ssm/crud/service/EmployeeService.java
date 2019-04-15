package com.ssm.crud.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ssm.crud.bean.Employee;
import com.ssm.crud.bean.EmployeeExample;
import com.ssm.crud.bean.EmployeeExample.Criteria;
import com.ssm.crud.dao.EmployeeMapper;

@Service
public class EmployeeService {

	@Autowired
	EmployeeMapper empMapper;

	/**
	 * ��ȡ����Ա���б�
	 * @return
	 */
	public List<Employee> getAll() {
		return empMapper.selectByExampleWithDept(null);
	}
	
	/**
	 * ����Ա������
	 * @param employee
	 */
	public void save(Employee employee) {
		empMapper.insertSelective(employee);
	}

	/**
	 * ����û����Ƿ��ظ�
	 * @param empName
	 * @return
	 */
	public Boolean checkName(String empName) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andEmpNameEqualTo(empName);
		long count = empMapper.countByExample(example);
		return count==0;
	}
	
	/**
	 * ��ȡԱ������
	 * @param id
	 * @return
	 */
	public Employee getEmp(Integer id) {
		Employee employee = empMapper.selectByPrimaryKey(id);
		return employee;
	}

	/**
	 * ����Ա������
	 * @param employee
	 */
	public void update(Employee employee) {
		empMapper.updateByPrimaryKeySelective(employee);
	}

	/**
	 * ����ɾ��Ա��
	 * @param id
	 */
	public void delEmp(Integer id) {
		empMapper.deleteByPrimaryKey(id);
	}
	
	/**
	 * ����ɾ��
	 * @param del_ids
	 */
	public void deleteBatch(List<Integer> del_ids) {
		EmployeeExample example = new EmployeeExample();
		Criteria criteria = example.createCriteria();
		criteria.andDIdIn(del_ids);
		empMapper.deleteByExample(example);
	}
	
	
}
