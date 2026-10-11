-- ============================================================
-- V13: Create Onboarding Tokens Table for Secure First-Login
-- KL University Academic Progress Tracking System
-- ============================================================

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
);

CREATE INDEX IF NOT EXISTS idx_onboarding_tokens_hash ON onboarding_tokens(token_hash);
CREATE INDEX IF NOT EXISTS idx_onboarding_tokens_student ON onboarding_tokens(student_id);
