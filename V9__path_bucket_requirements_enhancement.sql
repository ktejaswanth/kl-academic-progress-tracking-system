-- ============================================================
-- V9: Path Bucket Requirements Enhancement
-- KL University Academic Progress Tracking System
-- ============================================================

ALTER TABLE path_bucket_requirements ADD COLUMN IF NOT EXISTS min_credits INT DEFAULT 0;
ALTER TABLE path_bucket_requirements ADD COLUMN IF NOT EXISTS max_credits INT;
ALTER TABLE path_bucket_requirements ADD COLUMN IF NOT EXISTS max_courses INT;
ALTER TABLE path_bucket_requirements ADD COLUMN IF NOT EXISTS required_count INT;
ALTER TABLE path_bucket_requirements ADD COLUMN IF NOT EXISTS selection_rule VARCHAR(50) DEFAULT 'CREDIT_MINIMUM';
ALTER TABLE path_bucket_requirements ADD COLUMN IF NOT EXISTS grouping_code VARCHAR(50);
ALTER TABLE path_bucket_requirements ADD COLUMN IF NOT EXISTS rules_json JSONB;

-- Backfill min_credits from required_credits if zero
UPDATE path_bucket_requirements SET min_credits = required_credits WHERE min_credits = 0 AND required_credits > 0;

-- ============================================================
-- END OF V9 MIGRATION
-- ============================================================
