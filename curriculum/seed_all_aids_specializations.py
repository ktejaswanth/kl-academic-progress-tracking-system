import json
import re
import socket
import ssl
import sys
import pg8000

db_url = r"postgresql://postgres.xbhkyjgjunfzcxgnobss:UYKTSd$dc5Pe8/Q@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres"

def main():
    print("Connecting to Supabase PostgreSQL database...", flush=True)
    part1, part2 = db_url.split("@")
    user_pass = part1.replace("postgresql://", "")
    user, password = user_pass.split(":", 1)
    host_port, database = part2.split("/")
    host, port = host_port.split(":")

    host_dns = host if host.endswith('.') else host + '.'
    resolved_ip = socket.gethostbyname(host_dns)
    
    ssl_context = ssl.create_default_context()
    ssl_context.check_hostname = False
    ssl_context.verify_mode = ssl.CERT_NONE

    conn = pg8000.connect(
        user=user,
        password=password,
        host=resolved_ip,
        port=int(port),
        database=database,
        ssl_context=ssl_context
    )
    cursor = conn.cursor()
    print("Connected successfully.", flush=True)

    # 1. Load parsed specializations
    with open('curriculum/aids_specializations_parsed.json', 'r', encoding='utf-8') as f:
        specs_data = json.load(f)
    print(f"Loaded {len(specs_data)} specializations from JSON.", flush=True)

    # 2. Preload Course Catalog map (course_code -> course_id)
    cursor.execute("SELECT id, course_code FROM course_catalog")
    course_map = {row[1].strip(): row[0] for row in cursor.fetchall()}
    print(f"Preloaded {len(course_map)} courses from course_catalog.", flush=True)

    # Preload missing courses to bulk insert
    missing_courses = {}
    for s in specs_data:
        for c in s['courses']:
            code = c['course_code'].strip()
            if code not in course_map and code not in missing_courses:
                title = c.get('title', code)
                # escape quotes
                title_clean = title.replace("'", "''")
                missing_courses[code] = title_clean

    if missing_courses:
        print(f"Inserting {len(missing_courses)} missing courses into course_catalog...", flush=True)
        values_tuples = [f"('{code}', '{title}', 3)" for code, title in missing_courses.items()]
        chunk_size = 200
        for i in range(0, len(values_tuples), chunk_size):
            chunk = values_tuples[i : i + chunk_size]
            sql = f"INSERT INTO course_catalog (course_code, course_name, credits) VALUES {','.join(chunk)} ON CONFLICT (course_code) DO NOTHING"
            cursor.execute(sql)
        conn.commit()

        # Refresh map
        cursor.execute("SELECT id, course_code FROM course_catalog")
        course_map = {row[1].strip(): row[0] for row in cursor.fetchall()}
        print(f"Course catalog now has {len(course_map)} courses.", flush=True)

    # 3. Department and Version IDs
    aids_dept_id = 2
    aids_curriculum_version_id = 1

    # 4. Upsert specializations
    print("Upserting specializations...", flush=True)
    cursor.execute("SELECT id, code FROM specializations")
    existing_specs = {row[1]: row[0] for row in cursor.fetchall()}

    for s in specs_data:
        code = s['code'].replace("'", "''")
        name = s['name'].replace("'", "''")
        desc = f"Y23 B.Tech AIDS Specialization: {name}"

        if s['code'] in existing_specs:
            spec_id = existing_specs[s['code']]
            cursor.execute(f"""
                UPDATE specializations
                SET name = '{name}', description = '{desc}',
                    curriculum_version_id = {aids_curriculum_version_id},
                    department_id = {aids_dept_id}, is_active = true
                WHERE id = {spec_id}
            """)
        else:
            cursor.execute(f"""
                INSERT INTO specializations (curriculum_version_id, department_id, code, name, description, is_active)
                VALUES ({aids_curriculum_version_id}, {aids_dept_id}, '{code}', '{name}', '{desc}', true)
            """)
    conn.commit()

    # Preload specializations map
    cursor.execute("SELECT id, code FROM specializations")
    spec_map = {row[1]: row[0] for row in cursor.fetchall()}
    print(f"Total specializations in DB: {len(spec_map)}", flush=True)

    # 5. Preload existing specialization_courses to avoid duplicates
    cursor.execute("SELECT specialization_id, course_id FROM specialization_courses")
    existing_sc = set((row[0], row[1]) for row in cursor.fetchall())
    print(f"Existing specialization_courses count: {len(existing_sc)}", flush=True)

    # 6. Bulk insert new specialization courses
    sc_values = []
    for s in specs_data:
        code = s['code']
        spec_id = spec_map.get(code)
        if not spec_id:
            continue

        for idx, c in enumerate(s['courses']):
            course_code = c['course_code'].strip()
            course_id = course_map.get(course_code)
            if not course_id:
                continue

            if (spec_id, course_id) in existing_sc:
                continue

            bucket = c.get('bucket', 'PE').replace("'", "''")
            seq = idx + 1
            sc_values.append(f"({spec_id}, {aids_curriculum_version_id}, {course_id}, '{bucket}', {seq}, true)")
            existing_sc.add((spec_id, course_id))

    print(f"Prepared {len(sc_values)} new specialization_course rows to insert.", flush=True)

    if sc_values:
        chunk_size = 200
        for i in range(0, len(sc_values), chunk_size):
            chunk = sc_values[i : i + chunk_size]
            sql = f"""
                INSERT INTO specialization_courses (specialization_id, curriculum_version_id, course_id, role, sequence_no, required)
                VALUES {','.join(chunk)}
            """
            cursor.execute(sql)
        conn.commit()
        print(f"Successfully inserted {len(sc_values)} specialization course mappings!", flush=True)

    # 7. Final status verification
    cursor.execute("""
        SELECT count(*) FROM specializations 
        WHERE department_id = %s OR curriculum_version_id = %s
    """, (aids_dept_id, aids_curriculum_version_id))
    total_specs = cursor.fetchone()[0]

    cursor.execute("""
        SELECT count(sc.id) 
        FROM specialization_courses sc
        JOIN specializations s ON s.id = sc.specialization_id
        WHERE s.department_id = %s OR s.curriculum_version_id = %s
    """, (aids_dept_id, aids_curriculum_version_id))
    total_sc_courses = cursor.fetchone()[0]

    print("\n==================================================", flush=True)
    print("           Y23 AIDS SEEDING REPORT", flush=True)
    print("==================================================", flush=True)
    print(f"  • Y23 AIDS Specializations in DB     : {total_specs} (46 tracks)", flush=True)
    print(f"  • Mapped Specialization Courses in DB: {total_sc_courses}", flush=True)
    print("==================================================", flush=True)

    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
