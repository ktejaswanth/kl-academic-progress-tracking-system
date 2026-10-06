package com.example.demo.repository;

import com.example.demo.model.CompletedCourse;
import com.example.demo.model.Student;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CompletedCourseRepository extends JpaRepository<CompletedCourse, Long> {
    List<CompletedCourse> findByStudent(Student student);
    List<CompletedCourse> findByStudentId(Long studentId);
    List<CompletedCourse> findByStudentIdOrderByRegisterDateDesc(Long studentId);
    List<CompletedCourse> findByUniversityId(String universityId);
    List<CompletedCourse> findByUniversityIdOrderByRegisterDateDesc(String universityId);
    boolean existsByStudentIdAndCourseCode(Long studentId, String courseCode);
    boolean existsByUniversityIdAndCourseCode(String universityId, String courseCode);
    java.util.Optional<CompletedCourse> findFirstByUniversityIdAndCourseCode(String universityId, String courseCode);
    java.util.Optional<CompletedCourse> findFirstByUniversityIdAndCourseCodeAndSemesterAndAcademicYear(String universityId, String courseCode, String semester, String academicYear);
    long countByStudentId(Long studentId);
    long countByUniversityId(String universityId);
}
