import pg8000
import socket
import ssl
import re

def main():
    db_url = "postgresql://postgres:postgres@127.0.0.1:5435/postgres"
    
    pattern = re.compile(r"postgresql://(?P<user>[^:]+):(?P<password>[^@]+)@(?P<host>[^:]+):(?P<port>\d+)/(?P<database>.+)")
    m = pattern.match(db_url)
    params = m.groupdict()
    
    host = params['host']
    if host == "127.0.0.1" or host == "localhost":
        conn = pg8000.connect(
            user=params['user'],
            password=params['password'],
            host=host,
            port=int(params['port']),
            database=params['database']
        )
    else:
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
    
    tables = [
        "bucket_master",
        "department_master",
        "degree_type_master",
        "addon_type_master",
        "regulation_master",
        "degree_paths"
    ]
    
    print("--- Database Table Counts ---")
    for t in tables:
        try:
            cursor.execute(f"SELECT COUNT(*) FROM {t};")
            count = cursor.fetchone()[0]
            print(f"Table {t}: {count} rows")
        except Exception as e:
            print(f"Table {t}: Error: {e}")
            
    print("\n--- Regulation Master ---")
    try:
        cursor.execute("SELECT * FROM regulation_master;")
        for r in cursor.fetchall():
            print(r)
    except Exception as e:
        print("Error:", e)
        
    print("\n--- Department Master ---")
    try:
        cursor.execute("SELECT * FROM department_master;")
        for r in cursor.fetchall():
            print(r)
    except Exception as e:
        print("Error:", e)

    print("\n--- Degree Type Master ---")
    try:
        cursor.execute("SELECT * FROM degree_type_master;")
        for r in cursor.fetchall():
            print(r)
    except Exception as e:
        print("Error:", e)

    print("\n--- Addon Type Master ---")
    try:
        cursor.execute("SELECT * FROM addon_type_master;")
        for r in cursor.fetchall():
            print(r)
    except Exception as e:
        print("Error:", e)

    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
