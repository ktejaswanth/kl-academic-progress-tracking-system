import json

with open(r'curriculum/y23_path_bucket_requirements.json', 'r', encoding='utf-8') as f:
    reqs = json.load(f)

sql_lines = [
    '-- ============================================================',
    '-- V11: Seed Full Per-Bucket Path Requirements (CSE + AIDS)',
    '-- KL University Academic Progress Tracking System',
    '-- ============================================================',
    ''
]

for r in reqs:
    path_code = r['path_code']
    bucket_code = r['bucket_code']
    min_cr = r['min_credits']
    max_cr = r['max_credits']
    min_co = r['min_courses']
    max_co = r['max_courses']
    grouping = f"'{r['grouping']}'" if r['grouping'] else 'NULL'
    
    req_cr = max_cr if min_cr == 0 and max_cr > 0 else min_cr
    
    sql = f"""INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, max_credits, min_courses, max_courses, grouping_code, is_mandatory)
SELECT dp.id, bm.id, {req_cr}, {min_cr}, {max_cr}, {min_co}, {max_co}, {grouping}, true
FROM degree_paths dp, bucket_master bm
WHERE dp.path_code = '{path_code}' AND bm.bucket_code = '{bucket_code}'
ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET
    required_credits = EXCLUDED.required_credits,
    min_credits = EXCLUDED.min_credits,
    max_credits = EXCLUDED.max_credits,
    min_courses = EXCLUDED.min_courses,
    max_courses = EXCLUDED.max_courses,
    grouping_code = EXCLUDED.grouping_code;
"""
    sql_lines.append(sql)

with open('V11__seed_full_path_bucket_requirements.sql', 'w', encoding='utf-8') as f:
    f.write('\n'.join(sql_lines))

print(f'Generated V11 SQL with {len(reqs)} statements.')
