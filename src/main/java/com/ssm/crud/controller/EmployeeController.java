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
	 * ����������ɾ��
	 * ������� 1-2-3-4
	 * �������� 1
	 * 
	 */
	@RequestMapping(value="/emp/{ids}", method=RequestMethod.DELETE)
	@ResponseBody
	public Msg delEmp(@PathVariable("ids")String ids){
		//����ɾ��
		System.out.println(ids);
		if(ids.contains("-")){
			List<Integer> del_ids = new ArrayList<>();
			String [] str_ids = ids.split("-");
			//��װid�ļ���
			for (String string : str_ids) {
				del_ids.add(Integer.parseInt(string));
			}
			System.out.println(del_ids);
			empService.deleteBatch(del_ids);
		}
		//����ɾ��
		else{
			Integer id = Integer.parseInt(ids);
			empService.delEmp(id);
		}
		return Msg.success();
	}
	
	/**
	 * ����ɾ��
	 */
	/*@RequestMapping(value="/emp/{id}", method=RequestMethod.DELETE)
	@ResponseBody
	public Msg delEmp(@PathVariable("id")Integer id){
		empService.delEmp(id);
		return Msg.success();
	}*/
	
	/**
	 * ���ֱ�ӷ���ajax=PUT��ʽ������
	 * ��װ������
	 * 	Employee [empId=114, empName=null, gender=null, email=null, dId=null, dept=null]
	 * 
	 * ���⣺
	 * �������������ݣ���Employee�����װ����
	 * 	update tbl_emp where id = 114 �﷨����
	 * 
	 * ԭ��
	 * Tomcat:
	 * 	1. �������е����ݣ���װΪmap
	 * 	2. request.getParameter() �ͻ�����map��ȡֵ
	 * 	3. springMVC ��װPOJO�����ʱ��
	 * 		���POJO��ÿ�����Ե�ֵ��request.getParameter()
	 * 
	 * ajax����PUT��������⣺
	 * 	PUT�����������е����ݣ�request.getParameter()�ò���
	 * 	Tomcatһ��PUT,�����װ�������е�����Ϊmap��ֻ��post��ʽ������ŷ�װ������Ϊmap
	 * 
	 * �����
	 * 	web.xml ��������HttpPutFormContentFilter
	 * 	�������ã����������е����ݽ�����װ��һ��map��
	 * 	request�����°�װ��request.getParameter()����д���ͻ���Լ���װ��map�л�ȡ����
	 * 
	 * 
	 * ���±���Ա������
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
	 * ����id ��ȡԱ����Ϣ
	 * ���ڸ���Ա��, ������
	 */
	@RequestMapping(value="/emp/{id}", method=RequestMethod.GET)
	@ResponseBody
	public Msg getEmp(@PathVariable("id")Integer id){
		Employee emp = empService.getEmp(id);
		return Msg.success().add("emp", emp);
	}
	
	/**
	 * �û���У��
	 */
	@RequestMapping("checkName")
	@ResponseBody
	public Msg checkName(@RequestParam("empName")String empName){
		//�û����Ϸ�У��
		String regex = "(^[a-zA-Z0-9_-]{6,12}$)|(^[\u2E80-\u9FFF]{2,5})";
		if(!empName.matches(regex)){
			return Msg.fail().add("va_msg", "������2-5λ�����ַ�������6-12λӢ���ַ�������");
		}
		//�û����ظ�У��
		Boolean f = empService.checkName(empName);
		if(f){
			return Msg.success();
		}else{
			return Msg.fail().add("va_msg", "�û����ѱ�ռ��");
		}
	}
	
	/**
	 * ���Ա����Ϣ
	 * �û���Ϣ���У��JSR303
	 * ��Ҫhibernate-validator
	 */
	@RequestMapping(value="emp", method=RequestMethod.POST)
	@ResponseBody
	public Msg saveEmp(@Valid Employee employee, BindingResult result){
		if(result.hasErrors()){
			Map<String, Object> map = new HashMap<>();
			for(FieldError error: result.getFieldErrors()){
				System.out.println("������ֶ���: "+error.getField());
				System.out.println("�������Ϣ: "+error.getDefaultMessage());
				map.put(error.getField(), error.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}else{
			empService.save(employee);
		}
		return Msg.success();
	}
	
	/**
	 * ��ҳ������json����
	 * @ResponseBody��Ҫ����jackon��
	 */
	@ResponseBody
	@RequestMapping("/emps")
	public Msg getEmpsWithJson(@RequestParam(value="pn", defaultValue="1")Integer pn){
		//�����ҳ���
		//�ڲ�ѯ֮ǰ���ã�����ҳ�룬�Լ�ÿҳ�ļ�¼��
		PageHelper.startPage(pn, 5);
		//startPage ������������ѯ���Ƿ�ҳ��ѯ
		List<Employee> emps = empService.getAll();
		//ʹ��pageInfo ��װ��ѯ��Ľ����ֻ�轫pageInfo����ҳ�������
		//��װ����ϸ�ķ�ҳ��Ϣ�����������ǲ�ѯ���������ݣ�����������ʾ��ҳ��
		PageInfo page = new PageInfo(emps, 5);
		
		return Msg.success().add("pageInfo", page);
	}
	
	
	/**
	 * ��ҳ��ѯ
	 * @param pn ��ǰҳ��
	 * @param model
	 */
	/*@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pn", defaultValue="1")Integer pn, Model model){
		//�����ҳ���
		//�ڲ�ѯ֮ǰ���ã�����ҳ�룬�Լ�ÿҳ�ļ�¼��
		PageHelper.startPage(pn, 5);
		//startPage ������������ѯ���Ƿ�ҳ��ѯ
		List<Employee> emps = empService.getAll();
		//ʹ��pageInfo ��װ��ѯ��Ľ����ֻ�轫pageInfo����ҳ�������
		//��װ����ϸ�ķ�ҳ��Ϣ�����������ǲ�ѯ���������ݣ�����������ʾ��ҳ��
		PageInfo page = new PageInfo(emps, 5);
		model.addAttribute("pageInfo", page);
		return "list";
	}*/
	
	
}
