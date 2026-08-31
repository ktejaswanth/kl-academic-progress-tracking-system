import pg8000
import socket
import ssl
import re
from db_config import get_db_connection

def main():
    try:
        print("Connecting to DB...")
        conn = get_db_connection()
    except Exception as e:
        print("Error connecting:", e)
        return
        
    cursor = conn.cursor()
    
    print("--- Departments ---")
    cursor.execute("SELECT id, dept_code, dept_name FROM department_master")
    for r in cursor.fetchall():
        print(r)

    print("\n--- Regulations ---")
    cursor.execute("SELECT id, reg_code, reg_name, effective_year FROM regulation_master")
    for r in cursor.fetchall():
        print(r)

    print("\n--- Degree Types ---")
    cursor.execute("SELECT id, type_code, type_name FROM degree_type_master")
    for r in cursor.fetchall():
        print(r)

    print("\n--- Addon Types ---")
    cursor.execute("SELECT id, addon_code, addon_name FROM addon_type_master")
    for r in cursor.fetchall():
        print(r)

    print("\n--- Degree Programs ---")
    cursor.execute("SELECT id, code, name, branch, regulation FROM degree_programs")
    for r in cursor.fetchall():
        print(r)

    print("\n--- Bucket Master ---")
    cursor.execute("SELECT id, bucket_code, bucket_name, bucket_category FROM bucket_master ORDER BY bucket_code")
    for r in cursor.fetchall():
        print(r)

    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
