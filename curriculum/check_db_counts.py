from db_config import get_db_connection

def main():
    try:
        print("Connecting to DB...")
        conn = get_db_connection()
    except Exception as e:
        print("Error connecting:", e)
        return

    cursor = conn.cursor()
    tables = [
        "bucket_master",
        "degree_paths",
        "course_catalog",
        "path_bucket_requirements",
        "course_bucket_mapping",
        "users"
    ]
    
    print("\n--- Database Row Counts ---")
    for t in tables:
        try:
            cursor.execute(f"SELECT COUNT(*) FROM {t}")
            count = cursor.fetchone()[0]
            print(f"{t}: {count}")
        except Exception as e:
            print(f"Error reading {t}: {e}")
            conn.rollback()
            
    print("\n--- Database Users ---")
    try:
        cursor.execute("SELECT id, username, role, first_name FROM users")
        for row in cursor.fetchall():
            print(row)
    except Exception as e:
        print("Error reading users:", e)
        conn.rollback()
        
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
