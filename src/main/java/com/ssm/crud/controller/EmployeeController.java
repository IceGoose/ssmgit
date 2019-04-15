package com.ssm.crud.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.ssm.crud.bean.Employee;
import com.ssm.crud.bean.Msg;
import com.ssm.crud.service.EmployeeService;

@Controller
public class EmployeeController {
	
	@Autowired
	EmployeeService empService;
	
	/**
	 * 单个和批量删除
	 * 多个数据 1-2-3-4
	 * 单个数据 1
	 * 
	 */
	@RequestMapping(value="/emp/{ids}", method=RequestMethod.DELETE)
	@ResponseBody
	public Msg delEmp(@PathVariable("ids")String ids){
		//批量删除
		System.out.println(ids);
		if(ids.contains("-")){
			List<Integer> del_ids = new ArrayList<>();
			String [] str_ids = ids.split("-");
			//组装id的集合
			for (String string : str_ids) {
				del_ids.add(Integer.parseInt(string));
			}
			System.out.println(del_ids);
			empService.deleteBatch(del_ids);
		}
		//单个删除
		else{
			Integer id = Integer.parseInt(ids);
			empService.delEmp(id);
		}
		return Msg.success();
	}
	
	/**
	 * 单个删除
	 */
	/*@RequestMapping(value="/emp/{id}", method=RequestMethod.DELETE)
	@ResponseBody
	public Msg delEmp(@PathVariable("id")Integer id){
		empService.delEmp(id);
		return Msg.success();
	}*/
	
	/**
	 * 如果直接发送ajax=PUT形式的请求
	 * 封装的数据
	 * 	Employee [empId=114, empName=null, gender=null, email=null, dId=null, dept=null]
	 * 
	 * 问题：
	 * 请求体中有数据，但Employee对象封装不上
	 * 	update tbl_emp where id = 114 语法错误
	 * 
	 * 原因：
	 * Tomcat:
	 * 	1. 请求体中的数据，封装为map
	 * 	2. request.getParameter() 就会从这个map中取值
	 * 	3. springMVC 封装POJO对象的时候
	 * 		会把POJO中每个属性的值，request.getParameter()
	 * 
	 * ajax发送PUT请求的问题：
	 * 	PUT请求，请求体中的数据，request.getParameter()拿不到
	 * 	Tomcat一看PUT,不会封装请求体中的数据为map，只有post形式的请求才封装请求体为map
	 * 
	 * 解决：
	 * 	web.xml 中配置上HttpPutFormContentFilter
	 * 	他的作用：将请求体中的数据解析封装成一个map，
	 * 	request被重新包装，request.getParameter()被重写，就会从自己封装的map中获取数据
	 * 
	 * 
	 * 更新保存员工数据
	 * 
	 */
	@RequestMapping(value="/emp/{empId}", method=RequestMethod.PUT)
	@ResponseBody
	public Msg saveEmp(Employee employee){
		System.out.println(employee);
		empService.update(employee);
		return Msg.success();
	}
	
	
	/**
	 * 根据id 获取员工信息
	 * 用于更新员工, 表单回显
	 */
	@RequestMapping(value="/emp/{id}", method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id")Integer id){
		Employee emp = empService.getEmp(id);
		return Msg.success().add("emp", emp);
	}
	
	/**
	 * 用户名校验
	 */
	@RequestMapping("checkName")
	@ResponseBody
	public Msg checkName(@RequestParam("empName")String empName){
		//用户名合法校验
		String regex = "(^[a-zA-Z0-9_-]{6,12}$)|(^[\u2E80-\u9FFF]{2,5})";
		if(!empName.matches(regex)){
			return Msg.fail().add("va_msg", "请输入2-5位中文字符或输入6-12位英文字符和数字");
		}
		//用户名重复校验
		Boolean f = empService.checkName(empName);
		if(f){
			return Msg.success();
		}else{
			return Msg.fail().add("va_msg", "用户名已被占用");
		}
	}
	
	/**
	 * 添加员工信息
	 * 用户信息后端校验JSR303
	 * 需要hibernate-validator
	 */
	@RequestMapping(value="emp", method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee, BindingResult result){
		if(result.hasErrors()){
			Map<String, Object> map = new HashMap<>();
			for(FieldError error: result.getFieldErrors()){
				System.out.println("错误的字段名: "+error.getField());
				System.out.println("错误的信息: "+error.getDefaultMessage());
				map.put(error.getField(), error.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}else{
			empService.save(employee);
		}
		return Msg.success();
	}
	
	/**
	 * 分页，返回json对象
	 * @ResponseBody需要导入jackon包
	 */
	@ResponseBody
	@RequestMapping("/emps")
	public Msg getEmpsWithJson(@RequestParam(value="pn", defaultValue="1")Integer pn){
		//引入分页插件
		//在查询之前调用，传入页码，以及每页的记录数
		PageHelper.startPage(pn, 5);
		//startPage 后紧跟的这个查询就是分页查询
		List<Employee> emps = empService.getAll();
		//使用pageInfo 包装查询后的结果，只需将pageInfo交给页面就行了
		//封装了详细的分页信息，包括有我们查询出来的数据，传入连续显示的页数
		PageInfo page = new PageInfo(emps, 5);
		
		return Msg.success().add("pageInfo", page);
	}
	
	
	/**
	 * 分页查询
	 * @param pn 当前页码
	 * @param model
	 */
	/*@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn", defaultValue="1")Integer pn, Model model){
		//引入分页插件
		//在查询之前调用，传入页码，以及每页的记录数
		PageHelper.startPage(pn, 5);
		//startPage 后紧跟的这个查询就是分页查询
		List<Employee> emps = empService.getAll();
		//使用pageInfo 包装查询后的结果，只需将pageInfo交给页面就行了
		//封装了详细的分页信息，包括有我们查询出来的数据，传入连续显示的页数
		PageInfo page = new PageInfo(emps, 5);
		model.addAttribute("pageInfo", page);
		return "list";
	}*/
	
	
}
