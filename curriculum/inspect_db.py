from db_config import get_db_connection

def main():
    try:
        conn = get_db_connection()
    except Exception as e:
        print("Error connecting:", e)
        return
    cursor = conn.cursor()
    
    print("--- Curriculum Versions ---")
    cursor.execute("SELECT id, curriculum_code, version_name, department_id, regulation_id FROM curriculum_versions")
    for r in cursor.fetchall():
        print(r)

    print("\n--- Degree Paths ---")
    cursor.execute("SELECT id, path_code, department_id, degree_type_id, addon_type_id, curriculum_version_id, total_credits FROM degree_paths")
    paths = cursor.fetchall()
    print(f"Total paths: {len(paths)}")
    for p in paths[:10]:
        print(p)

    print("\n--- Curriculum Courses Count ---")
    try:
        cursor.execute("SELECT COUNT(*) FROM curriculum_courses")
        print("curriculum_courses:", cursor.fetchone()[0])
    except Exception as e:
        print("curriculum_courses error:", e)
        conn.rollback()

    print("\n--- Curriculum Course Mapping Count ---")
    try:
        cursor.execute("SELECT COUNT(*) FROM curriculum_course_mapping")
        print("curriculum_course_mapping:", cursor.fetchone()[0])
    except Exception as e:
        print("curriculum_course_mapping error:", e)
        conn.rollback()

    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
