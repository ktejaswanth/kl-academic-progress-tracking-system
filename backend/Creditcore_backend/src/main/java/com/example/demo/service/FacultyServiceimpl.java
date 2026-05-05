package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.demo.model.Faculty;
import com.example.demo.repository.FacultyRepository;

@Service
public class FacultyServiceimpl implements FacultyService{

	@Autowired
	private FacultyRepository facultyRepository;

	
	@Override
	public Faculty checkFacultyLogin(Faculty f) {
		// TODO Auto-generated method stub
		return facultyRepository.findByEmailAndPassword(f.getEmail(), f.getPassword());
	}

}
