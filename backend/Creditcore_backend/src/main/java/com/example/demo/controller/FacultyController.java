package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.demo.model.Faculty;
import com.example.demo.service.FacultyService;

@RestController
@RequestMapping("facultyapi")
@CrossOrigin("*")
public class FacultyController {

	@Autowired
	private FacultyService facultyService;
	
	@PostMapping("/login")
	public ResponseEntity<?> checkfacultylogin(@RequestBody Faculty f) 
	{
		try
		{
			Faculty faculty = facultyService.checkFacultyLogin(f);
			if (faculty != null) 
			{
				return ResponseEntity.status(200).body(faculty);
			}
			else 
			{
				return ResponseEntity.status(401).body("Faculty Login Failed");
			}
		}
		catch(Exception e)
		{
			return ResponseEntity.status(500).body(e.getMessage());
		}

	}
}
