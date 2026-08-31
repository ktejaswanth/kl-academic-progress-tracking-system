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

    with open(r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\V10__architecture_overhaul.sql", "r", encoding="utf-8") as f:
        sql = f.read()

    # Split statements
    statements = []
    current = []
    for line in sql.split('\n'):
        line_clean = line.strip()
        if not line_clean or line_clean.startswith('--'):
            continue
        if '--' in line:
            line = line.split('--')[0]
        current.append(line)
        if line.strip().endswith(';'):
            statements.append('\n'.join(current))
            current = []
    if current:
        statements.append('\n'.join(current))

    print(f"Executing {len(statements)} SQL statements...")
    for idx, stmt in enumerate(statements):
        stmt_clean = stmt.strip()
        if not stmt_clean:
            continue
        print(f"[{idx+1}/{len(statements)}] {stmt_clean[:60]}...")
        try:
            cursor.execute(stmt_clean)
        except Exception as e:
            print(f"Error at statement {idx+1}: {e}")
            conn.rollback()
            cursor.close()
            conn.close()
            return

    conn.commit()
    print("V10 migration applied and committed successfully!")
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
