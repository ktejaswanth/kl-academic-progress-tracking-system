from db_config import get_db_connection

def main():
    try:
        conn = get_db_connection()
    except Exception as e:
        print("Error connecting:", e)
        return
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
