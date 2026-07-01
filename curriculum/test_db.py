import psycopg2
import os

db_url = "postgresql://postgres.xbhkyjgjunfzcxgnobss:UYKTSd$$dc5Pe8/Q@aws-1-ap-northeast-2.pooler.supabase.com:6543/postgres?sslmode=require"

try:
    print("Connecting with URL...")
    conn = psycopg2.connect(db_url)
    print("Success!")
    cur = conn.cursor()
    cur.execute("SELECT version();")
    print(cur.fetchone())
    conn.close()
except Exception as e:
    print("Failed to connect:", e)
