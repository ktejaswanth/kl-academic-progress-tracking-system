import pg8000
import socket
import ssl
import re
import sys
from db_config import get_db_connection

def main():
    try:
        conn = get_db_connection()
    except Exception as e:
        print("Error connecting:", e)
        return
    cursor = conn.cursor()
    print("Connected successfully.", flush=True)

    with open("V11__seed_full_path_bucket_requirements.sql", "r", encoding="utf-8") as f:
        sql = f.read()

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

    print(f"Total statements to execute: {len(statements)}", flush=True)
    
    # Combine in batches of 50
    batch_size = 50
    total_batches = (len(statements) + batch_size - 1) // batch_size
    
    for b_idx in range(total_batches):
        batch = statements[b_idx * batch_size : (b_idx + 1) * batch_size]
        combined_sql = "\n".join(batch)
        try:
            cursor.execute(combined_sql)
            print(f"Executed batch {b_idx + 1}/{total_batches} ({len(batch)} stmts)", flush=True)
        except Exception as e:
            print(f"Error in batch {b_idx + 1}: {e}", flush=True)
            conn.rollback()
            cursor.close()
            conn.close()
            return

    conn.commit()
    print("V11 migration committed successfully!", flush=True)
    
    cursor.execute("SELECT COUNT(*) FROM path_bucket_requirements")
    count = cursor.fetchone()[0]
    print(f"Total path_bucket_requirements in database: {count}", flush=True)
    
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
