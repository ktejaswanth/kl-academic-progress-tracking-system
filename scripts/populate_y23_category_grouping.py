import os
import re
import pdfplumber
import psycopg2
from psycopg2.extras import execute_values
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "aws-1-ap-northeast-2.pooler.supabase.com")
DB_PORT = int(os.getenv("DB_PORT", "6543"))
DB_USER = os.getenv("DB_USER", "postgres.xbhkyjgjunfzcxgnobss")
DB_PASS = os.getenv("DB_PASSWORD", "UYKTSd$dc5Pe8/Q")
DB_NAME = os.getenv("DB_NAME", "postgres")

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
AIDS_PDF = os.path.join(BASE_DIR, "curriculum", "Y23 B.Tech - AIDS.pdf")
CSE_PDF = os.path.join(BASE_DIR, "curriculum", "Y23 B.Tech. - CSE.pdf")

if not os.path.exists(AIDS_PDF):
    AIDS_PDF = r"c:\Users\kteja\OneDrive\Desktop\Y23 B.Tech - AIDS.pdf"

if not os.path.exists(CSE_PDF):
    CSE_PDF = r"c:\Users\kteja\OneDrive\Desktop\Y23 B.Tech. - CSE.pdf"

def clean_str(val):
    if val is None:
        return None
    s = " ".join(str(val).strip().split())
    return s if s else None

def extract_cat_group_master(pdf_path, pages):
    print(f"Extracting Category & Grouping master from {pdf_path} pages {[p+1 for p in pages]}...", flush=True)
    rows = []
    with pdfplumber.open(pdf_path) as pdf:
        for pno in pages:
            page = pdf.pages[pno]
            for tbl in page.extract_tables() or []:
                for r in tbl:
                    if r and len(r) >= 3 and clean_str(r[0]) != "S#":
                        s_no = clean_str(r[0])
                        cat = clean_str(r[1])
                        grp = clean_str(r[2])
                        if s_no and (cat or grp):
                            rows.append((s_no, "Y23", cat, grp))
    print(f"Extracted {len(rows)} master category & grouping rows.", flush=True)
    return rows

def extract_course_group_mappings(pdf_path, start_page_idx, end_page_idx, dept_name):
    print(f"Extracting {dept_name} course-to-grouping mappings from page {start_page_idx+1} to {end_page_idx}...", flush=True)
    records = []
    current_heading = None

    with pdfplumber.open(pdf_path) as pdf:
        total = min(end_page_idx, len(pdf.pages))
        for pno in range(start_page_idx, total):
            page = pdf.pages[pno]
            tables = page.find_tables()
            words = page.extract_words()

            # Group words by line
            lines = []
            curr_line = []
            curr_top = None
            for w in words:
                if curr_top is None or abs(w['top'] - curr_top) < 4:
                    curr_line.append(w)
                    curr_top = w['top']
                else:
                    lines.append(curr_line)
                    curr_line = [w]
                    curr_top = w['top']
            if curr_line:
                lines.append(curr_line)

            # Detect headings
            headings = []
            for l in lines:
                line_text = " ".join([w['text'] for w in l])
                m = re.match(r'^\s*(\d+)\.\s+(MINOR|DOUBLE MAJOR|SPECIALIZATION|PROJECT):\s*(.*)', line_text, re.I)
                if m:
                    top_pos = l[0]['top']
                    num = m.group(1)
                    cat = m.group(2).upper()
                    grp = clean_str(m.group(3))
                    headings.append((top_pos, num, cat, grp))

            for t in tables:
                table_top = t.bbox[1]
                # Find closest heading above this table
                applicable_heading = None
                for h_top, num, cat, grp in reversed(headings):
                    if h_top < table_top:
                        applicable_heading = (num, cat, grp)
                        break
                
                if applicable_heading:
                    current_heading = applicable_heading

                extracted = t.extract()
                if not extracted:
                    continue
                for row in extracted:
                    if len(row) >= 14 and clean_str(row[3]) and clean_str(row[3]) != "CourseCode":
                        code = clean_str(row[3])
                        if current_heading:
                            records.append({
                                "course_code": code,
                                "s_no": current_heading[0],
                                "category": current_heading[1],
                                "group_name": current_heading[2],
                                "label": f"{current_heading[1]}: {current_heading[2]}"
                            })

    print(f"Extracted {len(records)} course mappings for {dept_name}.", flush=True)
    return records

def main():
    print("Connecting to Supabase PostgreSQL...", flush=True)
    conn = psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASS,
        dbname=DB_NAME
    )
    cur = conn.cursor()

    # 1. Apply DDL
    print("Creating category & grouping tables and adding column to course tables...", flush=True)
    ddl = """
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

    ALTER TABLE y23_aids_courses ADD COLUMN IF NOT EXISTS category_grouping TEXT;
    ALTER TABLE y23_cse_courses ADD COLUMN IF NOT EXISTS category_grouping TEXT;

    TRUNCATE TABLE y23_aids_course_grouping_mapping, y23_cse_course_grouping_mapping CASCADE;
    TRUNCATE TABLE y23_aids_category_grouping, y23_cse_category_grouping CASCADE;
    """
    cur.execute(ddl)
    conn.commit()

    # 2. Extract Master Groups
    # AIDS: pages 130 to 132 (idx 129 to 131)
    aids_master = extract_cat_group_master(AIDS_PDF, [129, 130, 131])
    # CSE: pages 132 to 134 (idx 131 to 133)
    cse_master = extract_cat_group_master(CSE_PDF, [131, 132, 133])

    # Insert master groups
    print(f"Inserting {len(aids_master)} rows into y23_aids_category_grouping...", flush=True)
    insert_master_sql = """
    INSERT INTO y23_aids_category_grouping (s_no, year, category, group_name)
    VALUES %s RETURNING id, s_no, category, group_name;
    """
    execute_values(cur, insert_master_sql, aids_master)
    cur.execute("SELECT id, s_no, category, group_name FROM y23_aids_category_grouping;")
    aids_id_map = {} # (s_no, group_name) -> id
    for row in cur.fetchall():
        aids_id_map[(row[1], row[3])] = row[0]
        aids_id_map[row[3]] = row[0]
    conn.commit()

    print(f"Inserting {len(cse_master)} rows into y23_cse_category_grouping...", flush=True)
    insert_master_cse_sql = """
    INSERT INTO y23_cse_category_grouping (s_no, year, category, group_name)
    VALUES %s RETURNING id, s_no, category, group_name;
    """
    execute_values(cur, insert_master_cse_sql, cse_master)
    cur.execute("SELECT id, s_no, category, group_name FROM y23_cse_category_grouping;")
    cse_id_map = {}
    for row in cur.fetchall():
        cse_id_map[(row[1], row[3])] = row[0]
        cse_id_map[row[3]] = row[0]
    conn.commit()

    # 3. Extract Course Groupings
    # AIDS: page 133 to 182 (idx 132 to 181)
    aids_course_maps = extract_course_group_mappings(AIDS_PDF, 132, 182, "AIDS")
    # CSE: page 135 to 213 (idx 134 to 212)
    cse_course_maps = extract_course_group_mappings(CSE_PDF, 134, 213, "CSE")

    # 4. Insert into mapping tables
    aids_db_mappings = []
    for m in aids_course_maps:
        grp_id = aids_id_map.get((m["s_no"], m["group_name"])) or aids_id_map.get(m["group_name"])
        aids_db_mappings.append((m["course_code"], grp_id, m["category"], m["group_name"]))

    print(f"Inserting {len(aids_db_mappings)} records into y23_aids_course_grouping_mapping...", flush=True)
    insert_cgm_sql = """
    INSERT INTO y23_aids_course_grouping_mapping (course_code, category_grouping_id, category, group_name)
    VALUES %s;
    """
    execute_values(cur, insert_cgm_sql, aids_db_mappings, page_size=500)
    conn.commit()

    cse_db_mappings = []
    for m in cse_course_maps:
        grp_id = cse_id_map.get((m["s_no"], m["group_name"])) or cse_id_map.get(m["group_name"])
        cse_db_mappings.append((m["course_code"], grp_id, m["category"], m["group_name"]))

    print(f"Inserting {len(cse_db_mappings)} records into y23_cse_course_grouping_mapping...", flush=True)
    insert_cgm_cse_sql = """
    INSERT INTO y23_cse_course_grouping_mapping (course_code, category_grouping_id, category, group_name)
    VALUES %s;
    """
    execute_values(cur, insert_cgm_cse_sql, cse_db_mappings, page_size=500)
    conn.commit()

    # 5. Connect/Update category_grouping in y23_aids_courses and y23_cse_courses
    print("Connecting and updating category_grouping column in y23_aids_courses...", flush=True)
    cur.execute("""
    WITH agg AS (
        SELECT course_code, string_agg(DISTINCT (category || ': ' || group_name), ' ; ' ORDER BY (category || ': ' || group_name)) AS cat_grp
        FROM y23_aids_course_grouping_mapping
        GROUP BY course_code
    )
    UPDATE y23_aids_courses c
    SET category_grouping = agg.cat_grp
    FROM agg
    WHERE c.course_code = agg.course_code;
    """)
    conn.commit()

    print("Connecting and updating category_grouping column in y23_cse_courses...", flush=True)
    cur.execute("""
    WITH agg AS (
        SELECT course_code, string_agg(DISTINCT (category || ': ' || group_name), ' ; ' ORDER BY (category || ': ' || group_name)) AS cat_grp
        FROM y23_cse_course_grouping_mapping
        GROUP BY course_code
    )
    UPDATE y23_cse_courses c
    SET category_grouping = agg.cat_grp
    FROM agg
    WHERE c.course_code = agg.course_code;
    """)
    conn.commit()

    # 6. Verification
    print("\n=== VERIFICATION RESULTS ===", flush=True)
    cur.execute("SELECT COUNT(*) FROM y23_aids_category_grouping;")
    print(f"y23_aids_category_grouping row count: {cur.fetchone()[0]}", flush=True)

    cur.execute("SELECT COUNT(*) FROM y23_cse_category_grouping;")
    print(f"y23_cse_category_grouping row count: {cur.fetchone()[0]}", flush=True)

    cur.execute("SELECT COUNT(*) FROM y23_aids_course_grouping_mapping;")
    print(f"y23_aids_course_grouping_mapping row count: {cur.fetchone()[0]}", flush=True)

    cur.execute("SELECT COUNT(*) FROM y23_cse_course_grouping_mapping;")
    print(f"y23_cse_course_grouping_mapping row count: {cur.fetchone()[0]}", flush=True)

    cur.execute("SELECT COUNT(*) FROM y23_aids_courses WHERE category_grouping IS NOT NULL;")
    print(f"y23_aids_courses with connected category_grouping: {cur.fetchone()[0]}", flush=True)

    cur.execute("SELECT COUNT(*) FROM y23_cse_courses WHERE category_grouping IS NOT NULL;")
    print(f"y23_cse_courses with connected category_grouping: {cur.fetchone()[0]}", flush=True)

    # Samples
    print("\nSample y23_aids_courses connected records:", flush=True)
    cur.execute("SELECT course_code, course_title, category_grouping FROM y23_aids_courses WHERE category_grouping IS NOT NULL LIMIT 4;")
    for r in cur.fetchall():
        print(" ", r, flush=True)

    print("\nSample y23_cse_courses connected records:", flush=True)
    cur.execute("SELECT course_code, course_title, category_grouping FROM y23_cse_courses WHERE category_grouping IS NOT NULL LIMIT 4;")
    for r in cur.fetchall():
        print(" ", r, flush=True)

    cur.close()
    conn.close()
    print("\nSynchronization completed successfully!", flush=True)

if __name__ == "__main__":
    main()
