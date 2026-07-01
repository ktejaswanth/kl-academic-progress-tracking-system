import re
import socket
import ssl

db_url = "postgresql://postgres.xbhkyjgjunfzcxgnobss:UYKTSd$dc5Pe8/Q@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres"

def main():
    try:
        import pg8000
        print("Connecting to DB...")
        pattern = re.compile(r"postgresql://(?P<user>[^:]+):(?P<password>[^@]+)@(?P<host>[^:]+):(?P<port>\d+)/(?P<database>.+)")
        m = pattern.match(db_url)
        if not m:
            print("Failed to parse db_url")
            return
        params = m.groupdict()
        
        host = params['host']
        dns_host = host if host.endswith('.') else host + '.'
        resolved_ip = socket.gethostbyname(dns_host)
        print(f"Resolved IP: {resolved_ip}")
        
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
