import os
import re
import pandas as pd
from datetime import datetime
import psycopg2
from psycopg2.extras import execute_values
from curriculum.db_config import load_dotenv_if_present

CSV_PATH = r"C:\Users\kteja\Downloads\y23_aids_studentdata_rows (1).csv"

def get_pg_connection():
    load_dotenv_if_present()
    raw_url = os.environ.get("DB_URL", "").replace("jdbc:", "").split("?")[0]
    user = os.environ.get("DB_USERNAME", "")
    password = os.environ.get("DB_PASSWORD", "")
    return psycopg2.connect(dsn=raw_url, user=user, password=password)

def parse_credits(ltps, cat_credits):
    if cat_credits is not None and cat_credits > 0:
        return int(cat_credits)
    if not ltps or pd.isna(ltps):
        return 3
    s = str(ltps).strip()
    try:
        return int(s)
    except ValueError:
        pass
    parts = re.split(r"[-:, /]+", s)
    nums = []
    for p in parts:
        try:
            nums.append(float(p))
        except ValueError:
            pass
    if len(nums) >= 4:
        cr = nums[0] + nums[1] + 0.5 * nums[2] + 0.5 * nums[3]
        return max(1, int(round(cr)))
    if len(nums) == 3:
        cr = nums[0] + nums[1] + 0.5 * nums[2]
        return max(1, int(round(cr)))
    if len(nums) == 1:
        return max(1, int(nums[0]))
    return 3

def parse_date(d_val):
    if pd.isna(d_val) or not d_val:
        return datetime.now().date()
    s = str(d_val).strip()
    for fmt in ("%Y-%m-%d", "%d-%m-%Y", "%d/%m/%Y", "%m/%d/%Y", "%Y/%m/%d", "%d-%b-%Y"):
        try:
            return datetime.strptime(s, fmt).date()
        except ValueError:
            pass
    return datetime.now().date()

def main():
    print(f"Reading CSV: {CSV_PATH}...")
    df = pd.read_csv(CSV_PATH)
    print(f"Total rows in CSV: {len(df)}")

    conn = get_pg_connection()
    cur = conn.cursor()

    # 1. Get verifier admin ID
    cur.execute("SELECT id FROM admins WHERE role = 'SUPER_ADMIN' LIMIT 1")
    admin_row = cur.fetchone()
    admin_id = admin_row[0] if admin_row else None
    print(f"Verifier Admin ID: {admin_id}")

    # 2. Sync missing students to students table (DO NOT USE users table)
    cur.execute("SELECT student_id, id FROM students")
    student_map = dict(cur.fetchall())

    unique_students = df[['university_id', 'student_name', 'branch', 'academic_year']].drop_duplicates(subset=['university_id'])
    
    default_pw_hash = "$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.TVuHOnC"
    missing_students_data = []

    for _, row in unique_students.iterrows():
        uid = str(row['university_id']).strip()
        name = str(row['student_name']).strip() if pd.notna(row['student_name']) else uid
        parts = name.split(None, 1)
        first_name = parts[0] if len(parts) > 0 else uid
        last_name = parts[1] if len(parts) > 1 else ""
        branch = str(row['branch']).strip() if pd.notna(row['branch']) else "AI&DS"
        email = f"{uid.lower()}@kluniversity.in"
        acad_yr = str(row['academic_year']).strip() if pd.notna(row['academic_year']) else "Y23"

        if uid not in student_map:
            missing_students_data.append((uid, first_name, last_name, email, default_pw_hash, uid, branch, "REGULAR", "NONE", "N/A", acad_yr, True, False))

    if missing_students_data:
        execute_values(cur, """
            INSERT INTO students (
                student_id, first_name, last_name, email, password, raw_password,
                department, sub_department, specialization_type, specialization_name,
                academic_year, is_active, first_login_completed, created_at
            ) VALUES %s
            ON CONFLICT (student_id) DO NOTHING
        """, missing_students_data, template="(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW())")
        print(f"Created {len(missing_students_data)} missing students in students table.")

    conn.commit()

    # Refresh student_map
    cur.execute("SELECT student_id, id FROM students")
    student_map = dict(cur.fetchall())

    # 3. Sync missing courses to course_catalog
    cur.execute("SELECT course_code, id, credits, course_name FROM course_catalog")
    cat_rows = cur.fetchall()
    cat_map = {r[0]: {'id': r[1], 'credits': r[2], 'name': r[3]} for r in cat_rows}

    unique_courses = df[['course_code', 'course_name', 'ltps', 'branch']].drop_duplicates(subset=['course_code'])
    missing_courses_data = []

    for _, row in unique_courses.iterrows():
        code = str(row['course_code']).strip().upper()
        name = str(row['course_name']).strip() if pd.notna(row['course_name']) else code
        ltps = str(row['ltps']).strip() if pd.notna(row['ltps']) else ""
        branch = str(row['branch']).strip() if pd.notna(row['branch']) else "AI&DS"

        if code not in cat_map:
            cr = parse_credits(ltps, None)
            missing_courses_data.append((code, name, cr, branch))

    if missing_courses_data:
        execute_values(cur, """
            INSERT INTO course_catalog (course_code, course_name, credits, category, created_at)
            VALUES %s
            ON CONFLICT (course_code) DO NOTHING
        """, missing_courses_data, template="(%s, %s, %s, %s, NOW())")
        conn.commit()
        print(f"Created {len(missing_courses_data)} missing courses in course_catalog.")

    # Refresh cat_map
    cur.execute("SELECT course_code, id, credits, course_name FROM course_catalog")
    cat_rows = cur.fetchall()
    cat_map = {r[0]: {'id': r[1], 'credits': r[2], 'name': r[3]} for r in cat_rows}

    # 4. Group rows by (university_id, course_code, semester, academic_year)
    print("Consolidating component rows by (university_id, course_code, semester, academic_year)...")
    grouped = {}
    for _, row in df.iterrows():
        uid = str(row['university_id']).strip()
        code = str(row['course_code']).strip().upper()
        sem = str(row['semester']).strip() if pd.notna(row['semester']) else "ODD"
        acad = str(row['academic_year']).strip() if pd.notna(row['academic_year']) else "2025-2026"
        ltps = str(row['ltps']).strip() if pd.notna(row['ltps']) else ""
        sec = str(row['section']).strip() if pd.notna(row['section']) else ""

        key = (uid, code, sem, acad)
        if key not in grouped:
            c_info = cat_map.get(code, {})
            c_name = str(row['course_name']).strip() if pd.notna(row['course_name']) else c_info.get('name', code)
            c_credits = parse_credits(ltps, c_info.get('credits'))
            reg_date = parse_date(row['register_date'])
            study_year = int(row['study_year']) if pd.notna(row['study_year']) and str(row['study_year']).isdigit() else 1

            grouped[key] = {
                'university_id': uid,
                'student_name': str(row['student_name']).strip() if pd.notna(row['student_name']) else "",
                'course_code': code,
                'course_name': c_name,
                'credits': c_credits,
                'ltps_set': [ltps] if ltps else [],
                'bucket_group': str(row['bucket_group']).strip() if pd.notna(row['bucket_group']) else "",
                'course_type': str(row['course_type']).strip() if pd.notna(row['course_type']) else "Regular",
                'academic_year': acad,
                'semester': sem,
                'study_year': study_year,
                'section_set': [sec] if sec else [],
                'register_date': reg_date,
                'course_ref': str(row['course_refid']).strip() if pd.notna(row['course_refid']) else "",
                'offer_to': str(row['offered_to']).strip() if pd.notna(row['offered_to']) else "",
                'offer_by': str(row['offered_by']).strip() if pd.notna(row['offered_by']) else "",
                'branch': str(row['branch']).strip() if pd.notna(row['branch']) else "AI&DS",
                'status': 'Completed'
            }
        else:
            if ltps and ltps not in grouped[key]['ltps_set']:
                grouped[key]['ltps_set'].append(ltps)
            if sec and sec not in grouped[key]['section_set']:
                grouped[key]['section_set'].append(sec)

    print(f"Total consolidated course records to push: {len(grouped)}")

    # 5. Clear previous data in completed_courses for these students
    uids_in_csv = list(set(k[0] for k in grouped.keys()))
    print(f"Clearing previous completed_courses for {len(uids_in_csv)} students...")
    cur.execute("DELETE FROM completed_courses WHERE university_id = ANY(%s)", (uids_in_csv,))
    conn.commit()

    # 6. Bulk insert with execute_values into completed_courses
    print("Performing bulk insert into completed_courses...")
    batch_cc = []

    for item in grouped.values():
        uid = item['university_id']
        student_db_id = student_map.get(uid)
        ltps_str = ", ".join(item['ltps_set'])
        sec_str = ", ".join(item['section_set'])

        batch_cc.append((
            student_db_id,
            uid,
            item['student_name'],
            item['course_code'],
            item['course_name'],
            item['credits'],
            item['semester'],
            ltps_str,
            item['bucket_group'],
            item['course_type'],
            item['academic_year'],
            item['study_year'],
            sec_str,
            item['course_ref'],
            item['offer_to'],
            item['offer_by'],
            item['branch'],
            item['register_date'],
            admin_id,
            item['status']
        ))

    execute_values(cur, """
        INSERT INTO completed_courses (
            student_id, university_id, student_name, course_code, course_name, credits,
            semester, ltps, bucket_group, course_type, academic_year, study_year,
            section_no, course_ref, offer_to, offer_by, branch, register_date,
            verified_by, status, created_at
        ) VALUES %s
    """, batch_cc, template="(%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW())", page_size=2000)

    conn.commit()

    print("\nSUCCESS! Data push completed successfully.")
    cur.execute("SELECT count(*) FROM completed_courses")
    print(f"Total in completed_courses table now: {cur.fetchone()[0]}")
    cur.execute("SELECT count(DISTINCT university_id) FROM completed_courses")
    print(f"Total distinct students with completed courses: {cur.fetchone()[0]}")

    conn.close()

if __name__ == '__main__':
    main()
