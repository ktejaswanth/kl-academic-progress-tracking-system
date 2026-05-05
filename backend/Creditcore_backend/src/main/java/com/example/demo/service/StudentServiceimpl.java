package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.model.Student;
import com.example.demo.repository.StudentRepository;

@Service
public class StudentServiceimpl implements StudentService {

	@Autowired
	private StudentRepository studentRepository;
	

	@Override
	public Student checkStudentLogin(Student s) 
	{
	   return studentRepository.findByEmailAndPassword(s.getEmail(), s.getPassword());
	}
}
