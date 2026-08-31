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
    
    # Select PIDs to terminate
    select_query = """
    SELECT pid, state, query 
    FROM pg_stat_activity 
    WHERE pid != pg_backend_pid() 
      AND (state LIKE 'idle in transaction%' AND state_change < NOW() - INTERVAL '15 seconds' OR state = 'active' AND query_start < NOW() - INTERVAL '2 minutes')
    """
    
    try:
        cursor.execute(select_query)
        rows = cursor.fetchall()
        print(f"Found {len(rows)} connections to terminate.")
        
        for r in rows:
            pid = r[0]
            state = r[1]
            query = r[2]
            print(f"Terminating PID: {pid} | State: {state} | Query: {query[:100]}")
            
            cursor.execute(f"SELECT pg_terminate_backend({pid})")
            res = cursor.fetchone()[0]
            print(f"  Result: {res}")
            
        conn.commit()
        print("All target connections terminated.")
    except Exception as e:
        print("Error terminating connections:", e)
        conn.rollback()
        
    cursor.close()
    conn.close()

if __name__ == "__main__":
    main()
