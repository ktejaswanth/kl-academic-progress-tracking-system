import re

def main():
    db_url = "postgresql://postgres.xbhkyjgjunfzcxgnobss:UYKTSd$dc5Pe8/Q@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres"
    
    try:
        import pg8000
        import socket
        import ssl
        print("Imported pg8000 successfully. Connecting to DB...")
        pattern = re.compile(r"postgresql://(?P<user>[^:]+):(?P<password>[^@]+)@(?P<host>[^:]+):(?P<port>\d+)/(?P<database>.+)")
        m = pattern.match(db_url)
        if not m:
            print("Failed to parse db_url")
            return
        params = m.groupdict()
        
        host = params['host']
        dns_host = host if host.endswith('.') else host + '.'
        print(f"Resolving DNS for {dns_host}...")
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
    except ImportError:
        print("pg8000 is not installed.")
        return

    cursor = conn.cursor()
    
    import sys
    sql_path = sys.argv[1] if len(sys.argv) > 1 else r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\V2__dyod_schema.sql"
    print(f"Reading SQL file from {sql_path}...")
    with open(sql_path, 'r', encoding='utf-8') as f:
        sql_content = f.read()
        
    # Split the SQL script into statements while ignoring comments
    statements = []
    current_statement = []
    
    for line in sql_content.split('\n'):
        line_stripped = line.strip()
        if not line_stripped or line_stripped.startswith('--'):
            continue
        # Remove inline comments if any
        if '--' in line:
            line = line.split('--')[0]
        current_statement.append(line)
        if line.strip().endswith(';'):
            statements.append("\n".join(current_statement))
            current_statement = []
            
    if current_statement:
        statements.append("\n".join(current_statement))
        
    print(f"Parsed {len(statements)} SQL statements. Executing sequentially...")
    
    for idx, stmt in enumerate(statements):
        stmt_clean = stmt.strip()
        if not stmt_clean:
            continue
        print(f"[{idx+1}/{len(statements)}] Executing statement: {stmt_clean[:60]}...")
        try:
            cursor.execute(stmt_clean)
        except Exception as e:
            print(f"\nFailed to execute statement {idx+1}:")
            print("--- STATEMENT ---")
            print(stmt_clean)
            print("-----------------")
            print("ERROR:", e)
            conn.rollback()
            cursor.close()
            conn.close()
            return
            
    conn.commit()
    print("\nAll SQL statements executed and committed successfully!")
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
