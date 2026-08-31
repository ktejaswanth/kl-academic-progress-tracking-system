import re
import socket
import ssl
from db_config import get_db_connection

def main():
    try:
        conn = get_db_connection()
    except Exception as e:
        print("Error connecting:", e)
        return

    cursor = conn.cursor()
    
    # Query active processes
    print("\n--- Active Queries in pg_stat_activity ---")
    query = """
    SELECT pid, state, query, wait_event_type, wait_event, backend_start, query_start
    FROM pg_stat_activity
    WHERE state != 'idle' AND pid != pg_backend_pid()
    """
    try:
        cursor.execute(query)
        rows = cursor.fetchall()
        for r in rows:
            print(f"PID: {r[0]} | State: {r[1]} | Wait: {r[3]}/{r[4]}")
            print(f"  Start: {r[5]} | Query Start: {r[6]}")
            print(f"  Query: {r[2][:200]}")
            print("-" * 50)
    except Exception as e:
        print("Error reading active queries:", e)
        conn.rollback()
        
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
