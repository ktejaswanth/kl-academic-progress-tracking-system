import pg8000
import socket
import ssl

def main():
    db_url = "postgresql://postgres.xbhkyjgjunfzcxgnobss:UYKTSd$dc5Pe8/Q@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres"
    
    import re
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
    cursor.execute("SELECT COUNT(*) FROM completed_courses;")
    count = cursor.fetchone()[0]
    print(f"Total Completed Courses: {count}")

    cursor.execute("SELECT u.username, c.course_code, c.course_name, c.ltps, c.bucket_group, c.created_at FROM completed_courses c JOIN users u ON c.student_id = u.id ORDER BY c.id DESC LIMIT 10;")
    rows = cursor.fetchall()
    
    print("--- Latest Completed Courses ---")
    for row in rows:
        print(row)

    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
