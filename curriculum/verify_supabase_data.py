import os
import sys
from pathlib import Path

# Add curriculum to sys.path
sys.path.insert(0, str(Path(__file__).resolve().parent))

try:
    from db_config import get_db_connection, load_dotenv_if_present
    load_dotenv_if_present()
    conn = get_db_connection()
    cursor = conn.cursor()
    print("SUCCESS: Connected to Supabase PostgreSQL database!\n")

    tables = [
        "department_master",
        "regulation_master",
        "degree_type_master",
        "addon_type_master",
        "bucket_master",
        "degree_paths",
        "path_bucket_requirements",
        "course_catalog",
        "curriculum_versions",
        "curriculum_courses",
        "curriculum_course_mapping",
        "students",
        "completed_courses",
        "specializations",
        "minor_programs"
    ]

    print(f"{'Table Name':<30} | {'Row Count':<10}")
    print("-" * 45)

    for table in tables:
        try:
            cursor.execute(f"SELECT COUNT(*) FROM {table}")
            cnt = cursor.fetchone()[0]
            print(f"{table:<30} | {cnt:<10}")
        except Exception as e:
            print(f"{table:<30} | ERROR: {e}")
            conn.rollback()

    print("\n--- SAMPLE DATA CHECKS ---")
    
    # 1. Check curriculum_versions
    cursor.execute("SELECT id, curriculum_code, version_name, status FROM curriculum_versions")
    rows = cursor.fetchall()
    print("\nCurriculum Versions:")
    for r in rows:
        print(f"  ID: {r[0]}, Code: {r[1]}, Name: {r[2]}, Status: {r[3]}")

    # 2. Check Degree Paths count by dept
    cursor.execute("""
        SELECT dm.dept_code, COUNT(dp.id) 
        FROM degree_paths dp
        LEFT JOIN department_master dm ON dp.department_id = dm.id
        GROUP BY dm.dept_code
    """)
    rows = cursor.fetchall()
    print("\nDegree Paths by Department:")
    for r in rows:
        print(f"  Dept: {r[0]}, Paths Count: {r[1]}")

    # 3. Check Course Catalog sample
    cursor.execute("SELECT course_code, course_name, credits FROM course_catalog LIMIT 5")
    rows = cursor.fetchall()
    print("\nCourse Catalog (Sample 5):")
    for r in rows:
        print(f"  {r[0]}: {r[1]} ({r[2]} credits)")

    # 4. Check Students sample
    cursor.execute("SELECT student_id, first_name, last_name, department FROM students LIMIT 5")
    rows = cursor.fetchall()
    print("\nStudents (Sample 5):")
    for r in rows:
        print(f"  {r[0]}: {r[1]} {r[2]} ({r[3]})")

    # 5. Check Completed Courses count
    cursor.execute("SELECT COUNT(DISTINCT university_id), COUNT(*) FROM completed_courses")
    r = cursor.fetchone()
    print(f"\nCompleted Courses: {r[1]} records across {r[0]} unique student IDs")

    cursor.close()
    conn.close()

except Exception as err:
    print(f"ERROR: {err}")
    import traceback
    traceback.print_exc()
