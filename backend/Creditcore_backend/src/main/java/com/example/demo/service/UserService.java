package com.example.demo.service;

import com.example.demo.model.*;
import com.example.demo.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional
public class UserService {

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private FacultyRepository facultyRepository;

    @Autowired
    private StudentRepository studentRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired(required = false)
    private UserRepository userRepository;

    // --- Admin Operations (stored ONLY in admins table) ---

    public Admin createAdmin(Map<String, Object> payload) {
        String empId = (String) payload.getOrDefault("empId", "");
        String username = (String) payload.get("username");
        if (username == null || username.trim().isEmpty()) {
            username = empId;
        }
        String firstName = (String) payload.get("firstName");
        String lastName = (String) payload.get("lastName");
        String email = (String) payload.get("email");
        String rawPassword = (String) payload.get("password");
        String designation = (String) payload.getOrDefault("designation", "Super Administrator");
        String contactNo = (String) payload.getOrDefault("contactNo", "");
        Boolean isActive = payload.get("isActive") != null ? Boolean.parseBoolean(payload.get("isActive").toString()) : true;

        if (username == null || username.trim().isEmpty()) {
            throw new RuntimeException("Username / Employee ID is required");
        }
        if (adminRepository.findByUsername(username).isPresent()) {
            throw new RuntimeException("Admin username already exists: " + username);
        }
        if (email != null && adminRepository.findByEmail(email).isPresent()) {
            throw new RuntimeException("Admin email already exists: " + email);
        }

        String encodedPassword = passwordEncoder.encode(rawPassword);

        // Stored ONLY in admins table
        Admin admin = new Admin();
        admin.setEmpId(empId.isEmpty() ? username : empId);
        admin.setUsername(username);
        admin.setFirstName(firstName);
        admin.setLastName(lastName);
        admin.setEmail(email);
        admin.setPassword(encodedPassword);
        admin.setRawPassword(rawPassword);
        admin.setIsActive(isActive);
        admin.setDesignation(designation);
        admin.setContactNo(contactNo);
        return adminRepository.save(admin);
    }

    public List<Admin> getAllAdmins() {
        return adminRepository.findAll();
    }

    public void deleteAdmin(Long id) {
        adminRepository.deleteById(id);
    }

    // --- Faculty Operations (stored ONLY in faculty table) ---

    public Faculty createFaculty(Map<String, Object> payload) {
        String empId = (String) payload.getOrDefault("empId", "");
        String username = (String) payload.get("username");
        if (username == null || username.trim().isEmpty()) {
            username = empId;
        }
        String firstName = (String) payload.get("firstName");
        String lastName = (String) payload.get("lastName");
        String email = (String) payload.get("email");
        String rawPassword = (String) payload.get("password");
        String designation = (String) payload.getOrDefault("designation", "Assistant Professor");
        String department = (String) payload.getOrDefault("department", "CSE");
        String cabinNo = (String) payload.getOrDefault("cabinNo", "");
        String contactNo = (String) payload.getOrDefault("contactNo", "");
        Boolean isActive = payload.get("isActive") != null ? Boolean.parseBoolean(payload.get("isActive").toString()) : true;

        if (username == null || username.trim().isEmpty()) {
            throw new RuntimeException("Employee ID / Username is required");
        }
        if (facultyRepository.findByUsername(username).isPresent()) {
            throw new RuntimeException("Faculty username already exists: " + username);
        }
        if (email != null && facultyRepository.findByEmail(email).isPresent()) {
            throw new RuntimeException("Faculty email already exists: " + email);
        }

        String encodedPassword = passwordEncoder.encode(rawPassword);

        // Stored ONLY in faculty table
        Faculty faculty = new Faculty();
        faculty.setEmpId(empId.isEmpty() ? username : empId);
        faculty.setUsername(username);
        faculty.setFirstName(firstName);
        faculty.setLastName(lastName);
        faculty.setEmail(email);
        faculty.setPassword(encodedPassword);
        faculty.setRawPassword(rawPassword);
        faculty.setIsActive(isActive);
        faculty.setDesignation(designation);
        faculty.setDepartment(department);
        faculty.setCabinNo(cabinNo);
        faculty.setContactNo(contactNo);
        faculty.setFirstLoginCompleted(false);
        return facultyRepository.save(faculty);
    }

    public Faculty createFaculty(User facultyUser) {
        Map<String, Object> map = new HashMap<>();
        map.put("empId", facultyUser.getEmpId() != null ? facultyUser.getEmpId() : facultyUser.getUsername());
        map.put("username", facultyUser.getUsername());
        map.put("firstName", facultyUser.getFirstName());
        map.put("lastName", facultyUser.getLastName());
        map.put("email", facultyUser.getEmail());
        map.put("password", facultyUser.getPassword() != null ? facultyUser.getPassword() : facultyUser.getRawPassword());
        map.put("designation", facultyUser.getDesignation());
        map.put("department", facultyUser.getDepartment());
        map.put("cabinNo", facultyUser.getCabinNo());
        map.put("contactNo", facultyUser.getContactNo());
        map.put("isActive", facultyUser.getIsActive());
        return createFaculty(map);
    }

    public List<Faculty> getAllFaculty() {
        return facultyRepository.findAll();
    }

    public void deleteFaculty(Long id) {
        facultyRepository.deleteById(id);
    }

    // --- Student Operations (stored ONLY in students table) ---

    public Student createStudent(Map<String, Object> payload) {
        String studentId = (String) payload.getOrDefault("studentId", payload.get("username"));
        String academicYear = (String) payload.getOrDefault("academicYear", "Y23");
        if ("2023-2024".equalsIgnoreCase(academicYear)) academicYear = "Y23";
        else if ("2024-2025".equalsIgnoreCase(academicYear)) academicYear = "Y24";
        else if ("2025-2026".equalsIgnoreCase(academicYear)) academicYear = "Y25";
        else if ("2026-2027".equalsIgnoreCase(academicYear)) academicYear = "Y26";
        String firstName = (String) payload.get("firstName");
        String lastName = (String) payload.get("lastName");
        String email = (String) payload.get("email");
        String rawPassword = (String) payload.get("password");
        String department = (String) payload.getOrDefault("department", "CSE");
        String subDepartment = (String) payload.getOrDefault("subDepartment", "REGULAR");
        String specializationType = (String) payload.getOrDefault("specializationType", "NONE");
        String specializationName = (String) payload.getOrDefault("specializationName", "");
        Boolean isActive = payload.get("isActive") != null ? Boolean.parseBoolean(payload.get("isActive").toString()) : true;

        if (studentId == null || studentId.trim().isEmpty()) {
            throw new RuntimeException("Student ID is required");
        }
        if (studentRepository.findByStudentId(studentId).isPresent()) {
            throw new RuntimeException("Student ID already exists: " + studentId);
        }
        if (email != null && studentRepository.findByEmail(email).isPresent()) {
            throw new RuntimeException("Student email already exists: " + email);
        }

        String encodedPassword = passwordEncoder.encode(rawPassword);

        // Stored ONLY in students table
        Student student = new Student();
        student.setStudentId(studentId);
        student.setAcademicYear(academicYear);
        student.setFirstName(firstName);
        student.setLastName(lastName);
        student.setEmail(email);
        student.setPassword(encodedPassword);
        student.setRawPassword(rawPassword);
        student.setIsActive(isActive);
        student.setDepartment(department);
        student.setSubDepartment(subDepartment);
        student.setSpecializationType(specializationType);
        student.setSpecializationName(specializationName);
        student.setFirstLoginCompleted(false);
        return studentRepository.save(student);
    }

    public Student createStudent(User studentUser) {
        Map<String, Object> map = new HashMap<>();
        map.put("studentId", studentUser.getUsername());
        map.put("academicYear", studentUser.getAcademicYear() != null ? studentUser.getAcademicYear() : "2023-2024");
        map.put("firstName", studentUser.getFirstName());
        map.put("lastName", studentUser.getLastName());
        map.put("email", studentUser.getEmail());
        map.put("password", studentUser.getPassword() != null ? studentUser.getPassword() : studentUser.getRawPassword());
        map.put("department", studentUser.getDepartment());
        map.put("subDepartment", studentUser.getSubDepartment());
        map.put("specializationType", studentUser.getSpecializationType());
        map.put("specializationName", studentUser.getSpecializationName());
        map.put("isActive", studentUser.getIsActive());
        return createStudent(map);
    }

    public List<Student> getAllStudents() {
        return studentRepository.findAll();
    }

    public void deleteStudent(Long id) {
        studentRepository.deleteById(id);
    }

    public Student updateStudentProfile(Long id, Map<String, Object> payload) {
        Student student = studentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Student not found with ID: " + id));

        String firstName = (String) payload.get("firstName");
        String lastName = (String) payload.get("lastName");
        String email = (String) payload.get("email");
        String dept = (String) payload.get("department");
        String subDept = (String) payload.get("subDepartment");
        String specType = (String) payload.get("specializationType");
        String specName = (String) payload.get("specializationName");
        String academicYear = (String) payload.get("academicYear");

        if (firstName != null) student.setFirstName(firstName);
        if (lastName != null) student.setLastName(lastName);
        if (email != null) student.setEmail(email);
        if (dept != null) student.setDepartment(dept);
        if (subDept != null) student.setSubDepartment(subDept);
        if (specType != null) student.setSpecializationType(specType);
        if (specName != null) student.setSpecializationName(specName);
        if (academicYear != null) student.setAcademicYear(academicYear);

        return studentRepository.save(student);
    }

    public Map<String, Long> getDashboardAnalytics() {
        Map<String, Long> analytics = new HashMap<>();
        long totalAdmins = adminRepository.count();
        long totalFaculty = facultyRepository.count();
        long totalStudents = studentRepository.count();
        analytics.put("totalUsers", totalAdmins + totalFaculty + totalStudents);
        analytics.put("totalAdmins", totalAdmins);
        analytics.put("totalFaculty", totalFaculty);
        analytics.put("totalStudents", totalStudents);
        return analytics;
    }

    public List<Map<String, Object>> getAllUsers() {
        List<Map<String, Object>> list = new java.util.ArrayList<>();
        adminRepository.findAll().forEach(a -> {
            Map<String, Object> m = new HashMap<>();
            m.put("id", a.getId());
            m.put("username", a.getUsername());
            m.put("role", "SUPER_ADMIN");
            m.put("email", a.getEmail());
            m.put("firstName", a.getFirstName());
            m.put("lastName", a.getLastName());
            m.put("isActive", a.getIsActive());
            list.add(m);
        });
        facultyRepository.findAll().forEach(f -> {
            Map<String, Object> m = new HashMap<>();
            m.put("id", f.getId());
            m.put("username", f.getUsername());
            m.put("role", "FACULTY");
            m.put("email", f.getEmail());
            m.put("firstName", f.getFirstName());
            m.put("lastName", f.getLastName());
            m.put("isActive", f.getIsActive());
            list.add(m);
        });
        studentRepository.findAll().forEach(s -> {
            Map<String, Object> m = new HashMap<>();
            m.put("id", s.getId());
            m.put("username", s.getStudentId());
            m.put("role", "STUDENT");
            m.put("email", s.getEmail());
            m.put("firstName", s.getFirstName());
            m.put("lastName", s.getLastName());
            m.put("isActive", s.getIsActive());
            list.add(m);
        });
        return list;
    }

    public void deleteUser(Long id) {
        if (userRepository != null && userRepository.existsById(id)) {
            userRepository.deleteById(id);
        }
    }
}
