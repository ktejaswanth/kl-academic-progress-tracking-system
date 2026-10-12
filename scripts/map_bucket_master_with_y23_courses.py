import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "aws-1-ap-northeast-2.pooler.supabase.com")
DB_PORT = int(os.getenv("DB_PORT", "6543"))
DB_USER = os.getenv("DB_USER", "postgres.xbhkyjgjunfzcxgnobss")
DB_PASS = os.getenv("DB_PASSWORD", "UYKTSd$dc5Pe8/Q")
DB_NAME = os.getenv("DB_NAME", "postgres")

def main():
    print("Connecting to Supabase PostgreSQL...", flush=True)
    conn = psycopg2.connect(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASS,
        dbname=DB_NAME
    )
    cur = conn.cursor()

    print("1. Normalizing sub_cat values...", flush=True)
    cur.execute("UPDATE y23_aids_courses SET sub_cat = 'AUC-CAREER' WHERE sub_cat = 'AUC- CAREER';")
    cur.execute("UPDATE y23_aids_courses SET sub_cat = 'SMFC-CORE' WHERE sub_cat = 'SMFC- CORE';")
    cur.execute("UPDATE y23_aids_courses SET sub_cat = 'PRI-CORE' WHERE sub_cat IS NULL AND cat = 'PRI';")
    cur.execute("UPDATE y23_aids_courses SET sub_cat = 'OE-CORE' WHERE sub_cat IS NULL AND cat = 'OEC';")

    cur.execute("UPDATE y23_cse_courses SET sub_cat = 'AUC-CAREER' WHERE sub_cat = 'AUC- CAREER';")
    cur.execute("UPDATE y23_cse_courses SET sub_cat = 'SMFC-CORE' WHERE sub_cat = 'SMFC- CORE';")
    conn.commit()

    print("2. Ensuring bucket_id columns and indexes exist...", flush=True)
    cur.execute("""
        ALTER TABLE y23_aids_courses ADD COLUMN IF NOT EXISTS bucket_id BIGINT REFERENCES bucket_master(id);
        ALTER TABLE y23_cse_courses ADD COLUMN IF NOT EXISTS bucket_id BIGINT REFERENCES bucket_master(id);

        CREATE INDEX IF NOT EXISTS idx_y23_aids_courses_bucket_id ON y23_aids_courses(bucket_id);
        CREATE INDEX IF NOT EXISTS idx_y23_cse_courses_bucket_id ON y23_cse_courses(bucket_id);
        CREATE INDEX IF NOT EXISTS idx_y23_aids_courses_sub_cat ON y23_aids_courses(sub_cat);
        CREATE INDEX IF NOT EXISTS idx_y23_cse_courses_sub_cat ON y23_cse_courses(sub_cat);
    """)
    conn.commit()

    print("3. Updating bucket_id from bucket_master on sub_cat = bucket_code...", flush=True)
    cur.execute("""
        UPDATE y23_aids_courses c
        SET bucket_id = b.id
        FROM bucket_master b
        WHERE c.sub_cat = b.bucket_code;
    """)
    cur.execute("""
        UPDATE y23_cse_courses c
        SET bucket_id = b.id
        FROM bucket_master b
        WHERE c.sub_cat = b.bucket_code;
    """)
    conn.commit()

    print("4. Creating convenience views...", flush=True)
    cur.execute("""
        CREATE OR REPLACE VIEW y23_aids_courses_with_bucket AS
        SELECT 
            c.*,
            b.bucket_name,
            b.description AS bucket_description
        FROM y23_aids_courses c
        LEFT JOIN bucket_master b ON c.sub_cat = b.bucket_code;

        CREATE OR REPLACE VIEW y23_cse_courses_with_bucket AS
        SELECT 
            c.*,
            b.bucket_name,
            b.description AS bucket_description
        FROM y23_cse_courses c
        LEFT JOIN bucket_master b ON c.sub_cat = b.bucket_code;
    """)
    conn.commit()

    cur.execute("SELECT COUNT(*), COUNT(bucket_id) FROM y23_aids_courses;")
    total_aids, aids_with_bucket = cur.fetchone()
    cur.execute("SELECT COUNT(*), COUNT(bucket_id) FROM y23_cse_courses;")
    total_cse, cse_with_bucket = cur.fetchone()

    print("\n=== VERIFICATION RESULTS ===", flush=True)
    print(f"y23_aids_courses: {aids_with_bucket} of {total_aids} mapped ({(aids_with_bucket/total_aids)*100:.1f}%)", flush=True)
    print(f"y23_cse_courses:  {cse_with_bucket} of {total_cse} mapped ({(cse_with_bucket/total_cse)*100:.1f}%)", flush=True)

    cur.close()
    conn.close()
    print("Mapping completed successfully!", flush=True)

if __name__ == "__main__":
    main()
