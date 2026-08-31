import os
import re
import json
import time
from db_config import get_db_connection

curr_dir = os.path.dirname(os.path.abspath(__file__))
cse_txt_path = os.path.join(curr_dir, "Y23_BTech_CSE_text.txt")
aids_txt_path = os.path.join(curr_dir, "Y23_BTech_AIDS_text.txt")

valid_buckets = {
    'HAS-CORE', 'HAS-FLE', 'HAS-MGE', 'BSC-CORE', 'BSC-ME-1', 'BSC-ME-2', 'BSC-ME-3',
    'BSC-ME-4', 'BSC-ME-5', 'BSC-SE-1', 'BSC-SE-2', 'BSC-SE-3', 'ESC-CORE', 'PCC-CORE', 'FC-1', 'FC-2', 'FCC',
    'HFC-CORE', 'HEC-CORE', 'HRC-CORE', 'HIC-CORE', 'SDP-1', 'SDP-2', 'SDP-3', 'SDP-4', 'SDC-CORE',
    'PE-1', 'PE-2', 'PE-3', 'PE-4', 'PE-5', 'PE-CORE', 'PRI-CORE', 'OE-1', 'OE-2', 'OE-3', 'OE-CORE',
    'VAC-SPORTS', 'VAC-CERT', 'VAC-CORE', 'AUC-CORE', 'AUC-CAREER', 'SIL-CORE', 'MIN-CORE', 'MIN-SDP',
    'SMFC-CORE', 'SMFC-SDP'
}

def map_title_to_codes(title, dept_code):
    title = re.sub(r"\s+", " ", title).strip()
    if "Honors through Experiential Learning" in title: type_code = "HTE"
    elif "Honors through Innovation" in title: type_code = "HTI"
    elif "Honors through Research" in title: type_code = "HTR"
    elif "Honors" in title: type_code = "HONORS"
    elif "No Flexibility" in title: type_code = "REGULAR"
    else: raise ValueError(f"Unknown: {title}")
        
    if "Minor" in title: addon_code = "MINOR"
    elif "Double Major" in title: addon_code = "DOUBLE_MAJOR"
    elif "Specialization" in title: addon_code = "SPECIALIZATION"
    elif "No Add-on" in title: addon_code = "NONE"
    else: raise ValueError(f"Unknown addon: {title}")
        
    path_code = f"{dept_code}-{type_code}"
    if addon_code != "NONE": path_code += f"-{addon_code}"
    return type_code, addon_code, path_code

def parse_curriculum_text(txt_path, dept_code, req_start, req_end, struct_start, struct_end):
    print(f"\nParsing {dept_code} from {txt_path}...")
    with open(txt_path, 'r', encoding='utf-8') as f:
        content = f.read()
    lines = content.split('\n')
    
    # 1. Requirements
    req_lines = lines[req_start:req_end]
    req_content = '\n'.join(req_lines)
    sections = re.split(r"\n(?=\d+\.\s+(?:Honors|No Flexibility))", req_content)
    
    requirements_rows = []
    paths_data = []
    
    for sect in sections:
        sect_lines = sect.strip().split('\n')
        if not sect_lines: continue
        match_header = re.match(r"^(\d+)\.\s+([^\n]+)", sect_lines[0])
        if not match_header: continue
        index_str, title = match_header.groups()
        try:
            type_code, addon_code, path_code = map_title_to_codes(title, dept_code)
        except ValueError:
            continue
            
        total_credit_match = re.search(r"Total Credit Required:\s*(\d+)", sect, re.IGNORECASE)
        total_credits = int(total_credit_match.group(1)) if total_credit_match else 0
        
        paths_data.append({
            'path_code': path_code,
            'type_code': type_code,
            'addon_code': addon_code,
            'total_credits': total_credits
        })
        
        for line in sect_lines:
            parts = line.strip().split()
            if len(parts) >= 7 and parts[0].isdigit() and parts[2] in valid_buckets:
                requirements_rows.append({
                    'Degree Path Code': path_code,
                    'Bucket Code': parts[2],
                    'Required Credits': int(float(parts[3]))
                })
                
    # 2. Courses
    structure_lines = lines[struct_start:struct_end]
    preprocessed_lines = []
    skip = False
    for i in range(len(structure_lines)):
        if skip:
            skip = False
            continue
        line_clean = structure_lines[i].strip()
        if line_clean.endswith('-') and i + 1 < len(structure_lines):
            merged_line = line_clean + structure_lines[i+1].strip()
            preprocessed_lines.append(merged_line + "\n")
            skip = True
        else:
            preprocessed_lines.append(structure_lines[i])
            
    courses_dict = {}
    current_course = None
    accumulated_lines = []
    
    metrics_pattern = re.compile(r"^(.*?)\b([A-Z])\s+([^\s]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)(.*)$")
    valid_categories = {'HAS', 'BSC', 'ESC', 'PCC', 'FCC', 'HFC', 'HEC', 'HRC', 'HIC', 'SDC', 'PEC', 'PRI', 'OEC', 'VAC', 'AUC', 'SIL', 'MIN', 'MSDC', 'SMFC'}
    
    for line_clean in preprocessed_lines:
        line_clean = line_clean.strip()
        if not line_clean: continue
            
        parts = line_clean.split()
        if len(parts) >= 4 and parts[0].isdigit() and parts[1] in valid_categories:
            if current_course and current_course['code'] and any(char.isdigit() for char in current_course['code']):
                courses_dict[current_course['code']] = current_course
                
            cat = parts[1]
            if parts[2][0].isdigit():
                code = parts[2]
                sub_cat = 'PRI-CORE' if cat == 'PRI' else ('OE-1' if cat == 'OEC' else ('VAC-CERT' if cat == 'VAC' else cat))
                rest_clean = " ".join(parts[3:])
            else:
                sub_cat = parts[2]
                code = parts[3]
                rest_clean = " ".join(parts[4:])
                
            current_course = {
                'code': code, 'sub_category': sub_cat, 'category': cat,
                'title': None, 'L': 0, 'T': 0, 'P': 0, 'S': 0, 'credits': 0.0, 'prereq': ''
            }
            accumulated_lines = [rest_clean] if rest_clean else []
            joined_text = " ".join(accumulated_lines)
            metrics_match = metrics_pattern.search(joined_text)
            if metrics_match:
                title_extra, mode, acronym, l, t, p, s, cr, ch, prereq = metrics_match.groups()
                current_course['title'] = title_extra.strip()
                current_course['L'] = int(l); current_course['T'] = int(t); current_course['P'] = int(p); current_course['S'] = int(s)
                current_course['credits'] = float(cr); current_course['prereq'] = prereq.strip()
                if any(char.isdigit() for char in current_course['code']):
                    courses_dict[current_course['code']] = current_course
                current_course = None
                accumulated_lines = []
            continue
            
        if current_course:
            if "Rule:" in line_clean or "=== PAGE" in line_clean or "Koneru Lakshmaiah" in line_clean or "Program Structure" in line_clean or "S# Cat Sub-Cat" in line_clean:
                continue
            accumulated_lines.append(line_clean)
            joined_text = " ".join(accumulated_lines)
            metrics_match = metrics_pattern.search(joined_text)
            if metrics_match:
                title_extra, mode, acronym, l, t, p, s, cr, ch, prereq = metrics_match.groups()
                current_course['title'] = re.sub(r"\s+", " ", title_extra.strip())
                current_course['L'] = int(l); current_course['T'] = int(t); current_course['P'] = int(p); current_course['S'] = int(s)
                current_course['credits'] = float(cr); current_course['prereq'] = prereq.strip()
                if any(char.isdigit() for char in current_course['code']):
                    courses_dict[current_course['code']] = current_course
                current_course = None
                accumulated_lines = []
                
    if current_course and current_course['code'] and any(char.isdigit() for char in current_course['code']):
        courses_dict[current_course['code']] = current_course

    courses_rows = []
    for code, c in courses_dict.items():
        courses_rows.append({
            'code': code,
            'name': c['title'] if c['title'] else "Unknown Course",
            'L': c['L'], 'T': c['T'], 'P': c['P'], 'S': c['S'],
            'credits': int(c['credits']),
            'prereq': c['prereq'] if c['prereq'] else "",
            'category': c['category'],
            'subcategory': c['sub_category']
        })
        
    print(f"Parsed {dept_code}: Paths={len(paths_data)}, Reqs={len(requirements_rows)}, Courses={len(courses_rows)}")
    return paths_data, requirements_rows, courses_rows

def escape_sql(val):
    if val is None: return "NULL"
    val_str = str(val).replace("'", "''")
    return f"'{val_str}'"

def main():
    cse_paths, cse_reqs, cse_courses = parse_curriculum_text(cse_txt_path, 'CSE', 1320, 2412, 2413, 9719)
    aids_paths, aids_reqs, aids_courses = parse_curriculum_text(aids_txt_path, 'AIDS', 1339, 2410, 2413, 10270)

    conn = get_db_connection()
    cursor = conn.cursor()

    # Get master mappings
    cursor.execute("SELECT id, dept_code FROM department_master")
    dept_map = {row[1]: row[0] for row in cursor.fetchall()}
    
    cursor.execute("SELECT id, reg_code FROM regulation_master")
    reg_map = {row[1]: row[0] for row in cursor.fetchall()}

    cursor.execute("SELECT id, type_code FROM degree_type_master")
    type_map = {row[1]: row[0] for row in cursor.fetchall()}

    cursor.execute("SELECT id, addon_code FROM addon_type_master")
    addon_map = {row[1]: row[0] for row in cursor.fetchall()}

    cursor.execute("SELECT id, bucket_code FROM bucket_master")
    bucket_map = {row[1]: row[0] for row in cursor.fetchall()}

    cursor.execute("SELECT id, curriculum_code FROM curriculum_versions")
    version_map = {row[1]: row[0] for row in cursor.fetchall()}

    def seed_department(dept_code, curr_code, paths_data, reqs_data, courses_data):
        curr_ver_id = version_map[curr_code]
        dept_id = dept_map[dept_code]
        reg_id = reg_map['Y23']
        
        print(f"\n--- Seeding {curr_code} (ID: {curr_ver_id}) ---")
        
        # 1. Degree paths
        path_db_map = {}
        for p in paths_data:
            path_code = p['path_code']
            type_id = type_map[p['type_code']]
            addon_id = addon_map[p['addon_code']]
            tot = p['total_credits']
            cursor.execute(
                """
                INSERT INTO degree_paths (path_code, department_id, degree_type_id, addon_type_id, regulation_id, curriculum_version_id, total_credits, is_active)
                VALUES (%s, %s, %s, %s, %s, %s, %s, true)
                ON CONFLICT (curriculum_version_id, path_code) 
                DO UPDATE SET total_credits = EXCLUDED.total_credits
                RETURNING id
                """,
                (path_code, dept_id, type_id, addon_id, reg_id, curr_ver_id, tot)
            )
            path_db_map[path_code] = cursor.fetchone()[0]
        conn.commit()
        print(f"  [OK] 20 Degree Paths Seeded.")
        
        # 2. Path Bucket Requirements in batches of 50
        batch_size = 50
        for i in range(0, len(reqs_data), batch_size):
            chunk = reqs_data[i:i + batch_size]
            vals = []
            for r in chunk:
                pid = path_db_map[r['Degree Path Code']]
                bid = bucket_map[r['Bucket Code']]
                cr = r['Required Credits']
                vals.append(f"({pid}, {bid}, {cr}, {cr}, true)")
            sql = f"INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, is_mandatory) VALUES {', '.join(vals)} ON CONFLICT (degree_path_id, bucket_id) DO UPDATE SET required_credits = EXCLUDED.required_credits, min_credits = EXCLUDED.min_credits;"
            cursor.execute(sql)
            conn.commit()
        print(f"  [OK] {len(reqs_data)} Path Bucket Requirements Seeded.")

        # 3. Course Catalog in batches of 50
        for i in range(0, len(courses_data), batch_size):
            chunk = courses_data[i:i + batch_size]
            vals = []
            for c in chunk:
                meta = json.dumps({"L": c['L'], "T": c['T'], "P": c['P'], "S": c['S'], "prerequisites": c['prereq']})
                vals.append(f"({escape_sql(c['code'])}, {escape_sql(c['name'])}, {c['credits']}, {escape_sql(c['category'])}, {escape_sql(meta)}::jsonb)")
            sql = f"INSERT INTO course_catalog (course_code, course_name, credits, category, metadata) VALUES {', '.join(vals)} ON CONFLICT (course_code) DO UPDATE SET course_name = EXCLUDED.course_name, credits = EXCLUDED.credits, metadata = EXCLUDED.metadata;"
            cursor.execute(sql)
            conn.commit()
        print(f"  [OK] {len(courses_data)} Courses Seeded in CourseCatalog.")

        # Load CourseCatalog IDs
        cursor.execute("SELECT course_code, id FROM course_catalog")
        cat_ids = {row[0]: row[1] for row in cursor.fetchall()}

        # 4. Curriculum Courses in batches of 50
        for i in range(0, len(courses_data), batch_size):
            chunk = courses_data[i:i + batch_size]
            vals = []
            for c in chunk:
                course_id = cat_ids[c['code']]
                vals.append(f"({curr_ver_id}, {course_id}, {escape_sql(c['name'])}, {c['credits']}, {c['L']}, {c['T']}, {c['P']}, {c['S']}, {escape_sql(c['category'])}, {escape_sql(c['subcategory'])}, {escape_sql(c['prereq'])})")
            sql = f"INSERT INTO curriculum_courses (curriculum_version_id, course_id, course_name, credits, lecture_hours, tutorial_hours, practical_hours, skill_hours, category, subcategory, prerequisite) VALUES {', '.join(vals)} ON CONFLICT (curriculum_version_id, course_id) DO UPDATE SET course_name = EXCLUDED.course_name, credits = EXCLUDED.credits, subcategory = EXCLUDED.subcategory;"
            cursor.execute(sql)
            conn.commit()
        print(f"  [OK] {len(courses_data)} Courses Seeded in CurriculumCourses.")

        # 5. Authoritative Curriculum Course Mappings
        sql_map = f"""
        INSERT INTO curriculum_course_mapping (curriculum_version_id, curriculum_course_id, bucket_id, mapping_source, mapping_confidence)
        SELECT cc.curriculum_version_id, cc.id, bm.id, 'OFFICIAL_PDF', 1.0
        FROM curriculum_courses cc
        JOIN bucket_master bm ON cc.subcategory = bm.bucket_code
        WHERE cc.curriculum_version_id = {curr_ver_id}
          AND NOT EXISTS (
              SELECT 1 FROM curriculum_course_mapping ccm
              WHERE ccm.curriculum_version_id = cc.curriculum_version_id 
                AND ccm.curriculum_course_id = cc.id 
                AND ccm.bucket_id = bm.id 
                AND ccm.degree_path_id IS NULL
          );
        """
        cursor.execute(sql_map)
        conn.commit()
        print(f"  [OK] Authoritative Curriculum Course Mappings created.")

        # 6. Legacy mappings for backward compatibility
        sql_legacy = f"""
        INSERT INTO course_bucket_mapping (course_id, bucket_id, is_mandatory)
        SELECT cc.course_id, bm.id, false
        FROM curriculum_courses cc
        JOIN bucket_master bm ON cc.subcategory = bm.bucket_code
        WHERE cc.curriculum_version_id = {curr_ver_id}
          AND NOT EXISTS (
              SELECT 1 FROM course_bucket_mapping cbm
              WHERE cbm.course_id = cc.course_id 
                AND cbm.bucket_id = bm.id 
                AND cbm.degree_path_id IS NULL
          );
        """
        cursor.execute(sql_legacy)
        conn.commit()
        print(f"  [OK] Legacy mappings synchronized.")

    seed_department('CSE', 'Y23-CSE', cse_paths, cse_reqs, cse_courses)
    seed_department('AIDS', 'Y23-AIDS', aids_paths, aids_reqs, aids_courses)

    cursor.close()
    conn.close()
    print("\n====================================================")
    print("ALL CURRICULA (CSE & AIDS) SEEDED SUCCESSFULLY!")
    print("====================================================")

if __name__ == "__main__":
    main()
