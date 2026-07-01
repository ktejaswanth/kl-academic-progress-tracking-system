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
    
    # Query active processes
    print("\n--- Active Queries in pg_stat_activity ---")
    query = """
    SELECT pid, state, query, wait_event_type, wait_event, backend_start, query_start
    FROM pg_stat_activity
    WHERE state != 'idle' AND pid != pg_backend_pid()
    """
    try:
        cursor.execute(query)
        rows = cursor.fetchall()
        for r in rows:
            print(f"PID: {r[0]} | State: {r[1]} | Wait: {r[3]}/{r[4]}")
            print(f"  Start: {r[5]} | Query Start: {r[6]}")
            print(f"  Query: {r[2][:200]}")
            print("-" * 50)
    except Exception as e:
        print("Error reading active queries:", e)
        conn.rollback()
        
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
