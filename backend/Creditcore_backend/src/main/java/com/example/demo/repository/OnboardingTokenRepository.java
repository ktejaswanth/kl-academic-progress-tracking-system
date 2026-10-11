package com.example.demo.repository;

import com.example.demo.model.OnboardingToken;
import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Repository
public interface OnboardingTokenRepository extends JpaRepository<OnboardingToken, Long> {

    Optional<OnboardingToken> findByTokenHash(String tokenHash);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT t FROM OnboardingToken t WHERE t.tokenHash = :tokenHash")
    Optional<OnboardingToken> findByTokenHashWithLock(@Param("tokenHash") String tokenHash);

    Optional<OnboardingToken> findByStudentIdAndIsUsedFalse(Long studentId);

    @Modifying
    @Transactional
    @Query("UPDATE OnboardingToken t SET t.passwordCreated = true WHERE t.id = :id AND t.passwordCreated = false")
    int markPasswordCreatedAtomic(@Param("id") Long id);

    @Modifying
    @Transactional
    void deleteByStudentId(Long studentId);
}
