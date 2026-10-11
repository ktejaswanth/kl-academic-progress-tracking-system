-- V15: Degree Outcome Requirements and Student Outcomes
-- Supports non-credit conditions specified in the official curriculum:
-- Minimum CGPA, Scopus publications, design patents, consultancy projects, backlog and betterment constraints.

CREATE TABLE IF NOT EXISTS degree_outcome_requirements (
    id                          BIGSERIAL PRIMARY KEY,
    degree_path_id              BIGINT NOT NULL REFERENCES degree_paths(id) ON DELETE CASCADE,
    min_cgpa                    NUMERIC(4,2) DEFAULT 0.0,
    min_scopus_publications     INT DEFAULT 0,
    min_design_patents          INT DEFAULT 0,
    min_consultancy_projects    INT DEFAULT 0,
    no_backlog_history          BOOLEAN DEFAULT false,
    no_betterment_history       BOOLEAN DEFAULT false,
    max_completion_years        INT DEFAULT 4,
    description                 TEXT,
    created_at                  TIMESTAMP DEFAULT NOW(),
    UNIQUE(degree_path_id)
);

CREATE TABLE IF NOT EXISTS student_outcomes (
    id                          BIGSERIAL PRIMARY KEY,
    student_id                  BIGINT NOT NULL REFERENCES students(id) ON DELETE CASCADE UNIQUE,
    cgpa                        NUMERIC(4,2) DEFAULT 0.0,
    scopus_publications         INT DEFAULT 0,
    design_patents              INT DEFAULT 0,
    consultancy_projects        INT DEFAULT 0,
    has_backlog_history         BOOLEAN DEFAULT false,
    has_betterment_history      BOOLEAN DEFAULT false,
    completion_years            INT DEFAULT 4,
    updated_at                  TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_dor_path ON degree_outcome_requirements(degree_path_id);
CREATE INDEX IF NOT EXISTS idx_so_student ON student_outcomes(student_id);
