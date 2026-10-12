-- V22: Create y23_aids_courses and y23_cse_courses tables from official curriculum PDFs
CREATE TABLE IF NOT EXISTS y23_aids_courses (
    id BIGSERIAL PRIMARY KEY,
    s_no TEXT,
    cat TEXT,
    sub_cat TEXT,
    course_code TEXT,
    course_title TEXT,
    mode TEXT,
    acrym TEXT,
    l NUMERIC,
    t NUMERIC,
    p NUMERIC,
    s NUMERIC,
    cr NUMERIC,
    ch NUMERIC,
    pre_req TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS y23_cse_courses (
    id BIGSERIAL PRIMARY KEY,
    s_no TEXT,
    cat TEXT,
    sub_cat TEXT,
    course_code TEXT,
    course_title TEXT,
    mode TEXT,
    acrym TEXT,
    l NUMERIC,
    t NUMERIC,
    p NUMERIC,
    s NUMERIC,
    cr NUMERIC,
    ch NUMERIC,
    pre_req TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_y23_aids_course_code ON y23_aids_courses(course_code);
CREATE INDEX IF NOT EXISTS idx_y23_cse_course_code ON y23_cse_courses(course_code);
