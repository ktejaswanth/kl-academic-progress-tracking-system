from db_config import get_db_connection

def main():
    conn = get_db_connection()
    cursor = conn.cursor()

    print("=== SUMMARY METRICS FOR Y23 AIDS ===")
    cursor.execute("SELECT count(*) FROM curriculum_courses WHERE curriculum_version_id = 1")
    print(f"Total Curriculum Courses (Y23-AIDS)       : {cursor.fetchone()[0]}")

    cursor.execute("SELECT count(*) FROM curriculum_course_mapping WHERE curriculum_version_id = 1")
    print(f"Total Course-Bucket Mappings (Y23-AIDS)   : {cursor.fetchone()[0]}")

    cursor.execute("SELECT count(*) FROM specializations WHERE department_id = 2 OR curriculum_version_id = 1")
    print(f"Total Specializations (Y23-AIDS)          : {cursor.fetchone()[0]}")

    cursor.execute("""
        SELECT count(sc.id) 
        FROM specialization_courses sc
        JOIN specializations s ON s.id = sc.specialization_id
        WHERE s.department_id = 2 OR s.curriculum_version_id = 1
    """)
    print(f"Total Specialization Courses (Y23-AIDS)   : {cursor.fetchone()[0]}")

    cursor.execute("""
        SELECT count(pbr.id)
        FROM path_bucket_requirements pbr
        JOIN degree_paths dp ON dp.id = pbr.degree_path_id
        WHERE dp.curriculum_version_id = 1
    """)
    print(f"Total Path Bucket Requirements (Y23-AIDS) : {cursor.fetchone()[0]}")

    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
