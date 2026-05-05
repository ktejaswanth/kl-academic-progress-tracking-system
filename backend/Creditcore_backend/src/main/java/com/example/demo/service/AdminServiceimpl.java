package com.example.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.model.Admin;
import com.example.demo.model.Faculty;
import com.example.demo.model.Student;
import com.example.demo.repository.AdminRepository;
import com.example.demo.repository.FacultyRepository;
import com.example.demo.repository.StudentRepository;

@Service
public class AdminServiceimpl implements AdminService{
	@Autowired
	private AdminRepository adminRepository;
	
	@Autowired
	private StudentRepository studentRepository;
	
	@Autowired
	private FacultyRepository facultyRepository;
	
	@Override
	public Admin checkAdminLogin(Admin a) 
	{	
		return adminRepository.findByUsernameAndPassword(a.getUsername(), a.getPassword());
	}
	
	@Override
	public String addStudent(Student s) 
	{
		studentRepository.save(s);	
		return "Student added successfully";
	}

	@Override
	public List<Student> viewAllStudents() 
	{
		return studentRepository.findAll();
	}

	@Override
	public String addFaculty(Faculty s) 
	{
	    facultyRepository.save(s);
	    return "Faculty Added Successfully";
	}

	@Override
	public List<Faculty> viewAllFaculty() 
	{
		  return facultyRepository.findAll();
	}
	
	
}
