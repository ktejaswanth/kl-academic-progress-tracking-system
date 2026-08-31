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
