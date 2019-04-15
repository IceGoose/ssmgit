package com.ssm.crud.test;

import java.util.List;
import java.util.UUID;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.ssm.crud.bean.Employee;
import com.ssm.crud.dao.DepartmentMapper;
import com.ssm.crud.dao.EmployeeMapper;

/**
 * ����dao��Ĺ���
 *	�Ƽ�Spring����Ŀ�Ϳ���ʹ�õ�Spring�ĵ�Ԫ���ԣ������Զ�ע��������Ҫ�����
 *	1. ����spring test ģ��
 *	2. @ContextConfigurationָ��Spring�����ļ�������
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations={"classpath:applicationContext.xml"})
public class MapperTest {
	
	@Autowired
	DepartmentMapper deptMapper;
	
	@Autowired
	EmployeeMapper empMapper;
	
	@Autowired
	SqlSession sqlSession;
	
	@Test
	public void testCrud(){
		
//		���벿������
//		deptMapper.insertSelective(new Department(null, "������"));
//		deptMapper.insertSelective(new Department(null, "���Բ�"));
		
//		����Ա������
//		empMapper.insertSelective(new Employee(null, "tom", "F", "tom@qq.com", 1));
		
//		��������Ա��
		/*EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
		for(int i=0; i<100; i++){
			int deptId = i % 2;
			String name = UUID.randomUUID().toString().substring(0, 5)+i;
			mapper.insertSelective(new Employee(null, name, "F", name+"ssm@163.com", deptId+1));
		}
		System.out.println("����ִ�����");*/
		
		List<Employee> list = empMapper.selectByExampleWithDept(null);
		for (Employee employee : list) {
			System.out.println(employee);
		}
	}
}
