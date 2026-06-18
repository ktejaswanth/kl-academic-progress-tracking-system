package com.example.demo.repository;

import com.example.demo.model.HonorsProgram;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HonorsProgramRepository extends JpaRepository<HonorsProgram, Long> {
    List<HonorsProgram> findByProgramId(Long programId);
}
