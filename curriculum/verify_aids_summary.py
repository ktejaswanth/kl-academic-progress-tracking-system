import pg8000
import socket
import ssl

db_url = r"postgresql://postgres.xbhkyjgjunfzcxgnobss:UYKTSd$dc5Pe8/Q@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres"

def main():
    part1, part2 = db_url.split("@")
    user_pass = part1.replace("postgresql://", "")
    user, password = user_pass.split(":", 1)
    host_port, database = part2.split("/")
    host, port = host_port.split(":")

    host_dns = host if host.endswith('.') else host + '.'
    resolved_ip = socket.gethostbyname(host_dns)
    
    ssl_context = ssl.create_default_context()
    ssl_context.check_hostname = False
    ssl_context.verify_mode = ssl.CERT_NONE

    conn = pg8000.connect(
        user=user,
        password=password,
        host=resolved_ip,
        port=int(port),
        database=database,
        ssl_context=ssl_context
    )
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
