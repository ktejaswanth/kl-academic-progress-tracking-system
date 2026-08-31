import re
import socket
import ssl
import pg8000
from db_config import get_db_connection

def main():
    try:
        print("Connecting to DB...")
        conn = get_db_connection()
    except Exception as e:
        print("Error connecting:", e)
        return
    cur = conn.cursor()
    
    for t in ["degree_paths", "path_bucket_requirements", "course_catalog", "curriculum_courses", "curriculum_course_mapping"]:
        cur.execute(f"SELECT COUNT(*) FROM {t}")
        print(f"{t}: {cur.fetchone()[0]}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
