package com.example.demo.config;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

@Component
public class OnboardingSchemaInitializer {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostConstruct
    public void initOnboardingTokenTable() {
        try {
            jdbcTemplate.execute("""
                CREATE TABLE IF NOT EXISTS onboarding_tokens (
                    id BIGSERIAL PRIMARY KEY,
                    token_hash VARCHAR(255) NOT NULL UNIQUE,
                    student_id BIGINT NOT NULL,
                    username VARCHAR(255) NOT NULL,
                    expiry_date TIMESTAMP NOT NULL,
                    password_created BOOLEAN NOT NULL DEFAULT FALSE,
                    is_used BOOLEAN NOT NULL DEFAULT FALSE,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    CONSTRAINT fk_onboarding_tokens_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
                )
            """);

            try {
                jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS idx_onboarding_tokens_hash ON onboarding_tokens(token_hash)");
                jdbcTemplate.execute("CREATE INDEX IF NOT EXISTS idx_onboarding_tokens_student ON onboarding_tokens(student_id)");
            } catch (Exception ignored) {}

            try {
                jdbcTemplate.execute("""
                    DO $$
                    BEGIN
                        IF NOT EXISTS (
                            SELECT 1 FROM pg_constraint WHERE conname = 'fk_onboarding_tokens_student'
                        ) THEN
                            ALTER TABLE onboarding_tokens 
                            ADD CONSTRAINT fk_onboarding_tokens_student 
                            FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;
                        END IF;
                    END $$;
                """);
            } catch (Exception ignored) {}
        } catch (Exception e) {
            System.err.println("Notice: OnboardingSchemaInitializer table verification: " + e.getMessage());
        }
    }
}
