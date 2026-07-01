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
    
    # Select PIDs to terminate
    select_query = """
    SELECT pid, state, query 
    FROM pg_stat_activity 
    WHERE pid != pg_backend_pid() 
      AND (state LIKE 'idle in transaction%' AND state_change < NOW() - INTERVAL '15 seconds' OR state = 'active' AND query_start < NOW() - INTERVAL '2 minutes')
    """
    
    try:
        cursor.execute(select_query)
        rows = cursor.fetchall()
        print(f"Found {len(rows)} connections to terminate.")
        
        for r in rows:
            pid = r[0]
            state = r[1]
            query = r[2]
            print(f"Terminating PID: {pid} | State: {state} | Query: {query[:100]}")
            
            cursor.execute(f"SELECT pg_terminate_backend({pid})")
            res = cursor.fetchone()[0]
            print(f"  Result: {res}")
            
        conn.commit()
        print("All target connections terminated.")
    except Exception as e:
        print("Error terminating connections:", e)
        conn.rollback()
        
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
