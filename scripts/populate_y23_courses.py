import os
import pdfplumber
import psycopg2
from psycopg2.extras import execute_values
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

DB_HOST = os.getenv("DB_HOST", "aws-1-ap-northeast-2.pooler.supabase.com")
DB_PORT = int(os.getenv("DB_PORT", "6543"))
DB_USER = os.getenv("DB_USER", "postgres.xbhkyjgjunfzcxgnobss")
DB_PASS = os.getenv("DB_PASSWORD", "UYKTSd$dc5Pe8/Q")
DB_NAME = os.getenv("DB_NAME", "postgres")

# Base directory for PDFs
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
    s = str(val).strip()
    s = " ".join(s.split())
    return s if s else None

def clean_num(val):
    if val is None:
        return None
    s = str(val).strip().replace("\n", "").replace(" ", "")
    if not s or s.lower() in ["nil", "na", "n/a", "-", "--", "none", "*"]:
        return None
    try:
        return float(s)
    except ValueError:
        return None

def extract_courses_from_pdf(pdf_path, start_page_idx, end_page_idx, dept_name):
    print(f"Extracting {dept_name} from {pdf_path} (page {start_page_idx+1} to {end_page_idx})...", flush=True)
    records = []
    with pdfplumber.open(pdf_path) as pdf:
        for pno in range(start_page_idx, end_page_idx):
            page = pdf.pages[pno]
            tables = page.extract_tables()
            for t in tables:
                if not t or len(t) < 2:
                    continue
                for row in t[1:]: # skip header row
                    if len(row) >= 14:
                        s_no = clean_str(row[0])
                        cat = clean_str(row[1])
                        sub_cat = clean_str(row[2])
                        code = clean_str(row[3])
                        title = clean_str(row[4])
                        mode = clean_str(row[5])
                        acrym = clean_str(row[6])
                        l = clean_num(row[7])
                        t_val = clean_num(row[8])
                        p = clean_num(row[9])
                        s = clean_num(row[10])
                        cr = clean_num(row[11])
                        ch = clean_num(row[12])
                        pre_req = clean_str(row[13])

                        # Ensure valid course row
                        if code and code != "CourseCode":
                            records.append((
                                s_no, cat, sub_cat, code, title, mode, acrym,
                                l, t_val, p, s, cr, ch, pre_req
                            ))
    print(f"Total {dept_name} courses extracted: {len(records)}", flush=True)
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

    # 1. Create tables
    print("Dropping and creating tables with TEXT types...", flush=True)
    ddl = """
    DROP TABLE IF EXISTS y23_aids_courses CASCADE;
    DROP TABLE IF EXISTS y23_cse_courses CASCADE;

    CREATE TABLE y23_aids_courses (
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

    CREATE TABLE y23_cse_courses (
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
    """
    cur.execute(ddl)
    conn.commit()
    print("Tables created cleanly.", flush=True)

    # 2. Extract AIDS Courses (Page 72 to 129)
    aids_courses = extract_courses_from_pdf(AIDS_PDF, 71, 129, "AIDS")

    # 3. Extract CSE Courses (Page 71 to 131)
    cse_courses = extract_courses_from_pdf(CSE_PDF, 70, 131, "CSE")

    # 4. Insert into y23_aids_courses
    print(f"Inserting {len(aids_courses)} courses into y23_aids_courses...", flush=True)
    insert_sql_aids = """
    INSERT INTO y23_aids_courses (
        s_no, cat, sub_cat, course_code, course_title, mode, acrym,
        l, t, p, s, cr, ch, pre_req
    ) VALUES %s;
    """
    execute_values(cur, insert_sql_aids, aids_courses, page_size=200)
    conn.commit()

    # 5. Insert into y23_cse_courses
    print(f"Inserting {len(cse_courses)} courses into y23_cse_courses...", flush=True)
    insert_sql_cse = """
    INSERT INTO y23_cse_courses (
        s_no, cat, sub_cat, course_code, course_title, mode, acrym,
        l, t, p, s, cr, ch, pre_req
    ) VALUES %s;
    """
    execute_values(cur, insert_sql_cse, cse_courses, page_size=200)
    conn.commit()

    # 6. Verify row counts
    cur.execute("SELECT COUNT(*) FROM y23_aids_courses;")
    cnt_aids = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM y23_cse_courses;")
    cnt_cse = cur.fetchone()[0]

    print("\n=== VERIFICATION RESULTS ===", flush=True)
    print(f"y23_aids_courses row count: {cnt_aids}", flush=True)
    print(f"y23_cse_courses  row count: {cnt_cse}", flush=True)

    cur.close()
    conn.close()
    print("\nDatabase synchronization completed successfully!", flush=True)

if __name__ == "__main__":
    main()
