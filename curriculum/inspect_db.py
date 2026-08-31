import pg8000
import socket
import ssl
import re

db_url = "postgresql://postgres.xbhkyjgjunfzcxgnobss:UYKTSd$dc5Pe8/Q@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres"

def main():
    pattern = re.compile(r"postgresql://(?P<user>[^:]+):(?P<password>[^@]+)@(?P<host>[^:]+):(?P<port>\d+)/(?P<database>.+)")
    m = pattern.match(db_url)
    params = m.groupdict()
    host = params['host']
    dns_host = host if host.endswith('.') else host + '.'
    resolved_ip = socket.gethostbyname(dns_host)
    
    ssl_context = ssl.create_default_context()
    ssl_context.check_hostname = False
    ssl_context.verify_mode = ssl.CERT_NONE
    
    conn = pg8000.connect(
        user=params['user'],
        password=params['password'],
        host=resolved_ip,
        port=int(params['port']),
        database=params['database'],
        ssl_context=ssl_context
    )
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
