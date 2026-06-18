package com.example.demo.repository;

import com.example.demo.model.DegreeProgram;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DegreeProgramRepository extends JpaRepository<DegreeProgram, Long> {
    Optional<DegreeProgram> findByCode(String code);
}
