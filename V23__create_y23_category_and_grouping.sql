-- V23: Create y23_aids_category_grouping and y23_cse_category_grouping tables
-- and link category_grouping to y23_aids_courses and y23_cse_courses

CREATE TABLE IF NOT EXISTS y23_aids_category_grouping (
    id BIGSERIAL PRIMARY KEY,
    s_no TEXT,
    year TEXT DEFAULT 'Y23',
    category TEXT,
    group_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS y23_cse_category_grouping (
    id BIGSERIAL PRIMARY KEY,
    s_no TEXT,
    year TEXT DEFAULT 'Y23',
    category TEXT,
    group_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_y23_aids_catgrp_group_name ON y23_aids_category_grouping(group_name);
CREATE INDEX IF NOT EXISTS idx_y23_cse_catgrp_group_name ON y23_cse_category_grouping(group_name);

-- Relational mappings connecting courses to their category groupings
CREATE TABLE IF NOT EXISTS y23_aids_course_grouping_mapping (
    id BIGSERIAL PRIMARY KEY,
    course_code TEXT NOT NULL,
    category_grouping_id BIGINT REFERENCES y23_aids_category_grouping(id) ON DELETE CASCADE,
    category TEXT,
    group_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS y23_cse_course_grouping_mapping (
    id BIGSERIAL PRIMARY KEY,
    course_code TEXT NOT NULL,
    category_grouping_id BIGINT REFERENCES y23_cse_category_grouping(id) ON DELETE CASCADE,
    category TEXT,
    group_name TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_y23_aids_cgm_course_code ON y23_aids_course_grouping_mapping(course_code);
CREATE INDEX IF NOT EXISTS idx_y23_cse_cgm_course_code ON y23_cse_course_grouping_mapping(course_code);

-- Add category_grouping column directly to course tables
ALTER TABLE y23_aids_courses ADD COLUMN IF NOT EXISTS category_grouping TEXT;
ALTER TABLE y23_cse_courses ADD COLUMN IF NOT EXISTS category_grouping TEXT;

CREATE INDEX IF NOT EXISTS idx_y23_aids_courses_catgrp ON y23_aids_courses(category_grouping);
CREATE INDEX IF NOT EXISTS idx_y23_cse_courses_catgrp ON y23_cse_courses(category_grouping);
