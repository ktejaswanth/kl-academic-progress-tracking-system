import json
import pg8000
import socket
import ssl
import re

db_url = "postgresql://postgres.xbhkyjgjunfzcxgnobss:UYKTSd$dc5Pe8/Q@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres"

def main():
    print("Connecting to DB...")
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
    
    # 1. Fetch degree_paths map
    cursor.execute("SELECT id, path_code FROM degree_paths")
    path_map = {row[1]: row[0] for row in cursor.fetchall()}
    print(f"Loaded {len(path_map)} degree paths from DB.")
    
    # 2. Fetch bucket_master map
    cursor.execute("SELECT id, bucket_code FROM bucket_master")
    bucket_map = {row[1]: row[0] for row in cursor.fetchall()}
    print(f"Loaded {len(bucket_map)} buckets from DB.")
    
    # 3. Load requirements JSON
    with open("curriculum/y23_path_bucket_requirements.json", "r", encoding="utf-8") as f:
        reqs = json.load(f)
    print(f"Loaded {len(reqs)} requirements from JSON.")
    
    values_list = []
    skipped = 0
    for r in reqs:
        path_code = r['path_code']
        bucket_code = r['bucket_code']
        
        path_id = path_map.get(path_code)
        bucket_id = bucket_map.get(bucket_code)
        
        if not path_id or not bucket_id:
            skipped += 1
            continue
            
        min_cr = r['min_credits']
        max_cr = r['max_credits']
        min_co = r['min_courses']
        max_co = r['max_courses']
        grouping = f"'{r['grouping']}'" if r['grouping'] else 'NULL'
        req_cr = max_cr if min_cr == 0 and max_cr > 0 else min_cr
        
        values_list.append(f"({path_id}, {bucket_id}, {req_cr}, {min_cr}, {max_cr}, {min_co}, {max_co}, {grouping}, true)")
        
    print(f"Prepared {len(values_list)} values (skipped {skipped}).")
    
    # Insert in chunks of 200
    chunk_size = 200
    for i in range(0, len(values_list), chunk_size):
        chunk = values_list[i : i + chunk_size]
        insert_sql = f"""
        INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
        VALUES {','.join(chunk)}
        ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
            required_credits = EXCLUDED.required_credits,
            min_credits = EXCLUDED.min_credits,
            max_credits = EXCLUDED.max_credits,
            min_courses = EXCLUDED.min_courses,
            max_courses = EXCLUDED.max_courses,
            grouping_code = EXCLUDED.grouping_code;
        """
        cursor.execute(insert_sql)
        print(f"Inserted chunk {i//chunk_size + 1}/{(len(values_list) + chunk_size - 1)//chunk_size}")
        
    conn.commit()
    print("V11 full path bucket requirements successfully committed!")
    
    cursor.execute("SELECT COUNT(*) FROM path_bucket_requirements")
    count = cursor.fetchone()[0]
    print(f"Total path_bucket_requirements count in DB: {count}")
    
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
