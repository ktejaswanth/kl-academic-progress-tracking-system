-- ============================================================
-- V12: Remove Users Table & Repoint All FKs to Students Table
-- KL University Academic Progress Tracking System
-- ============================================================

-- 1. Migrate student_id references from users.id to students.id
UPDATE student_bucket_progress sbp
SET student_id = s.id
FROM users u
JOIN students s ON u.username = s.student_id
WHERE sbp.student_id = u.id;

UPDATE student_degree_path sdp
SET student_id = s.id
FROM users u
JOIN students s ON u.username = s.student_id
WHERE sdp.student_id = u.id;

UPDATE student_degree_status sds
SET student_id = s.id
FROM users u
JOIN students s ON u.username = s.student_id
WHERE sds.student_id = u.id;

-- 2. Drop existing foreign keys pointing to users
ALTER TABLE student_selections DROP CONSTRAINT IF EXISTS fkqm7nsiaexp5y13t4bmd6fgsho;
ALTER TABLE upload_history DROP CONSTRAINT IF EXISTS fkgbr2is3gd9pcmcpg9w9nmq6bs;
ALTER TABLE audit_history DROP CONSTRAINT IF EXISTS fkdnwvkjybpuhnfydmidmjj4ni7;
ALTER TABLE audit_history DROP CONSTRAINT IF EXISTS fkpu4py9ykhyupdnykianvabdyc;
ALTER TABLE completed_courses DROP CONSTRAINT IF EXISTS fkgvfnx2cefu55k5frjmisp71e9;
ALTER TABLE eligibility_results DROP CONSTRAINT IF EXISTS fkswbqxxe14nn150r2vkeny83ho;
ALTER TABLE password_reset_tokens DROP CONSTRAINT IF EXISTS fkk3ndxg5xp6v7wd4gjyusp15gq;
ALTER TABLE student_bucket_progress DROP CONSTRAINT IF EXISTS fko2g7d6xm7slf8usj95nq4pwjo;
ALTER TABLE student_course_attempts DROP CONSTRAINT IF EXISTS fke9ubc2kyvv8ie8klun4mvryfd;
ALTER TABLE student_courses DROP CONSTRAINT IF EXISTS fk4celjueb4wixygpkjagooyeok;
ALTER TABLE student_degree_path DROP CONSTRAINT IF EXISTS fkbhth53pkwi1hmkyr12mwwim7j;
ALTER TABLE student_degree_path DROP CONSTRAINT IF EXISTS fkgxhgdtnw406ep16nla4h1jtnp;
ALTER TABLE student_degree_status DROP CONSTRAINT IF EXISTS fksaqwwd5qfbnig8e0omc9a28mk;
ALTER TABLE student_issues DROP CONSTRAINT IF EXISTS fkb7aw4ubsja03rc8xlly2uguwf;
ALTER TABLE student_profiles DROP CONSTRAINT IF EXISTS fk32koy3tgqtaujxhfsn0b9pel2;

-- 3. Add foreign keys pointing to students(id)
ALTER TABLE student_bucket_progress ADD CONSTRAINT fk_student_bucket_progress_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;
ALTER TABLE student_degree_path ADD CONSTRAINT fk_student_degree_path_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;
ALTER TABLE student_degree_status ADD CONSTRAINT fk_student_degree_status_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;
ALTER TABLE student_courses ADD CONSTRAINT fk_student_courses_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;
ALTER TABLE student_course_attempts ADD CONSTRAINT fk_student_course_attempts_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;
ALTER TABLE student_issues ADD CONSTRAINT fk_student_issues_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;
ALTER TABLE student_profiles ADD CONSTRAINT fk_student_profiles_student FOREIGN KEY (user_id) REFERENCES students(id) ON DELETE CASCADE;
ALTER TABLE student_selections ADD CONSTRAINT fk_student_selections_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;
ALTER TABLE eligibility_results ADD CONSTRAINT fk_eligibility_results_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;
ALTER TABLE audit_history ADD CONSTRAINT fk_audit_history_student FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE;

-- 4. Drop users table completely
DROP TABLE IF EXISTS users CASCADE;
