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
 * 测试dao层的工作
 *	推荐Spring的项目就可以使用的Spring的单元测试，可以自动注入我们需要的组件
 *	1. 导入spring test 模块
 *	2. @ContextConfiguration指定Spring配置文件的配置
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
		
//		插入部门数据
//		deptMapper.insertSelective(new Department(null, "开发部"));
//		deptMapper.insertSelective(new Department(null, "测试部"));
		
//		插入员工数据
//		empMapper.insertSelective(new Employee(null, "tom", "F", "tom@qq.com", 1));
		
//		批量插入员工
		/*EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
		for(int i=0; i<100; i++){
			int deptId = i % 2;
			String name = UUID.randomUUID().toString().substring(0, 5)+i;
			mapper.insertSelective(new Employee(null, name, "F", name+"ssm@163.com", deptId+1));
		}
		System.out.println("批量执行完成");*/
		
		List<Employee> list = empMapper.selectByExampleWithDept(null);
		for (Employee employee : list) {
			System.out.println(employee);
		}
	}
}
