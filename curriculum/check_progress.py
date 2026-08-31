import re
import socket
import ssl
import pg8000

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
    cur = conn.cursor()
    
    for t in ["degree_paths", "path_bucket_requirements", "course_catalog", "curriculum_courses", "curriculum_course_mapping"]:
        cur.execute(f"SELECT COUNT(*) FROM {t}")
        print(f"{t}: {cur.fetchone()[0]}")
        
    cur.close()
    conn.close()

if __name__ == "__main__":
    main()
