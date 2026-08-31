import re
import pandas as pd
import json
from db_config import get_db_connection

cse_txt_path = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\Y23_BTech_CSE_text.txt"
aids_txt_path = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\Y23_BTech_AIDS_text.txt"

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
    
    if "Honors through Experiential Learning" in title:
        type_code = "HTE"
    elif "Honors through Innovation" in title:
        type_code = "HTI"
    elif "Honors through Research" in title:
        type_code = "HTR"
    elif "Honors" in title:
        type_code = "HONORS"
    elif "No Flexibility" in title:
        type_code = "REGULAR"
    else:
        raise ValueError(f"Unknown flexibility in title: {title}")
        
    if "Minor" in title:
        addon_code = "MINOR"
    elif "Double Major" in title:
        addon_code = "DOUBLE_MAJOR"
    elif "Specialization" in title:
        addon_code = "SPECIALIZATION"
    elif "No Add-on" in title:
        addon_code = "NONE"
    else:
        raise ValueError(f"Unknown addon in title: {title}")
        
    path_code = f"{dept_code}-{type_code}"
    if addon_code != "NONE":
        path_code += f"-{addon_code}"
        
    return type_code, addon_code, path_code

def parse_curriculum_text(txt_path, dept_code, req_start, req_end, struct_start, struct_end):
    print(f"\n==========================================")
    print(f"Parsing {dept_code} from {txt_path}...")
    print(f"==========================================")
    with open(txt_path, 'r', encoding='utf-8') as f:
        content = f.read()
    lines = content.split('\n')
    
    # 1. Parse Requirements
    req_lines = lines[req_start:req_end]
    req_content = '\n'.join(req_lines)
    sections = re.split(r"\n(?=\d+\.\s+(?:Honors|No Flexibility))", req_content)
    
    requirements_rows = []
    paths_data = []
    
    for sect in sections:
        sect_lines = sect.strip().split('\n')
        if not sect_lines:
            continue
        header = sect_lines[0]
        match_header = re.match(r"^(\d+)\.\s+([^\n]+)", header)
        if not match_header:
            continue
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
                sub_cat = parts[2]
                min_cred = int(float(parts[3]))
                requirements_rows.append({
                    'Degree Path Code': path_code,
                    'Bucket Code': sub_cat,
                    'Required Credits': min_cred
                })
                
    # 2. Parse Courses
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
        if not line_clean:
            continue
            
        parts = line_clean.split()
        if len(parts) >= 4 and parts[0].isdigit() and parts[1] in valid_categories:
            if current_course and current_course['code'] and any(char.isdigit() for char in current_course['code']):
                courses_dict[current_course['code']] = current_course
                
            cat = parts[1]
            
            if parts[2][0].isdigit():
                code = parts[2]
                if cat == 'PRI':
                    sub_cat = 'PRI-CORE'
                elif cat == 'OEC':
                    sub_cat = 'OE-1'
                elif cat == 'VAC':
                    sub_cat = 'VAC-CERT'
                else:
                    sub_cat = cat
                rest_clean = " ".join(parts[3:])
            else:
                sub_cat = parts[2]
                code = parts[3]
                rest_clean = " ".join(parts[4:])
                
            current_course = {
                'code': code,
                'sub_category': sub_cat,
                'category': cat,
                'title': None,
                'L': 0, 'T': 0, 'P': 0, 'S': 0, 'credits': 0.0,
                'prereq': ''
            }
            accumulated_lines = [rest_clean] if rest_clean else []
            
            joined_text = " ".join(accumulated_lines)
            metrics_match = metrics_pattern.search(joined_text)
            if metrics_match:
                title_extra, mode, acronym, l, t, p, s, cr, ch, prereq = metrics_match.groups()
                current_course['title'] = title_extra.strip()
                current_course['L'] = int(l)
                current_course['T'] = int(t)
                current_course['P'] = int(p)
                current_course['S'] = int(s)
                current_course['credits'] = float(cr)
                current_course['prereq'] = prereq.strip()
                
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
                full_title = title_extra.strip()
                full_title = re.sub(r"\s+", " ", full_title)
                
                current_course['title'] = full_title
                current_course['L'] = int(l)
                current_course['T'] = int(t)
                current_course['P'] = int(p)
                current_course['S'] = int(s)
                current_course['credits'] = float(cr)
                current_course['prereq'] = prereq.strip()
                
                if any(char.isdigit() for char in current_course['code']):
                    courses_dict[current_course['code']] = current_course
                current_course = None
                accumulated_lines = []
                
    if current_course and current_course['code'] and any(char.isdigit() for char in current_course['code']):
        courses_dict[current_course['code']] = current_course

    courses_rows = []
    mappings_rows = []
    
    for code, c in courses_dict.items():
        courses_rows.append({
            'Course Code': code,
            'Course Name': c['title'] if c['title'] else "Unknown Course",
            'L': c['L'],
            'T': c['T'],
            'P': c['P'],
            'S': c['S'],
            'Credits': int(c['credits']),
            'Prerequisites': c['prereq'] if c['prereq'] else "",
            'Category': c['category'],
            'SubCategory': c['sub_category']
        })
        mappings_rows.append({
            'Course Code': code,
            'Bucket Code': c['sub_category'],
            'Degree Path Code (Optional)': ""
        })
        
    print(f"Results for {dept_code}:")
    print(f"  - Degree Paths: {len(paths_data)}")
    print(f"  - Requirements: {len(requirements_rows)}")
    print(f"  - Courses: {len(courses_rows)}")
    print(f"  - Mappings: {len(mappings_rows)}")
    
    return paths_data, requirements_rows, courses_rows, mappings_rows

def seed_database():
    cse_paths, cse_reqs, cse_courses, cse_maps = parse_curriculum_text(
        cse_txt_path, 'CSE', 1320, 2412, 2413, 9719
    )
    aids_paths, aids_reqs, aids_courses, aids_maps = parse_curriculum_text(
        aids_txt_path, 'AIDS', 1339, 2410, 2413, 10270
    )
    
    # Save Excel files
    pd.DataFrame(cse_courses).to_excel(r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\cse_courses.xlsx", index=False)
    pd.DataFrame(cse_reqs).to_excel(r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\cse_requirements.xlsx", index=False)
    pd.DataFrame(cse_maps).to_excel(r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\cse_mappings.xlsx", index=False)

    pd.DataFrame(aids_courses).to_excel(r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\aids_courses.xlsx", index=False)
    pd.DataFrame(aids_reqs).to_excel(r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\aids_requirements.xlsx", index=False)
    pd.DataFrame(aids_maps).to_excel(r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\aids_mappings.xlsx", index=False)

    conn = get_db_connection()
    cursor = conn.cursor()
    
    print("\n--- Seeding Database (Optimized Batch Mode) ---")
    
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

    print("Loaded master mappings successfully.")
    
    def process_dept(dept_code, curr_code, paths_data, reqs_data, courses_data):
        curr_ver_id = version_map[curr_code]
        dept_id = dept_map[dept_code]
        reg_id = reg_map['Y23']
        
        print(f"\nProcessing {curr_code} (Curriculum Version ID: {curr_ver_id})...")
        
        # 1. Degree Paths
        path_db_map = {}
        for p in paths_data:
            path_code = p['path_code']
            type_id = type_map[p['type_code']]
            addon_id = addon_map[p['addon_code']]
            total_credits = p['total_credits']
            
            cursor.execute(
                """
                INSERT INTO degree_paths (path_code, department_id, degree_type_id, addon_type_id, regulation_id, curriculum_version_id, total_credits, is_active)
                VALUES (%s, %s, %s, %s, %s, %s, %s, true)
                ON CONFLICT (curriculum_version_id, path_code) 
                DO UPDATE SET total_credits = EXCLUDED.total_credits, department_id = EXCLUDED.department_id, regulation_id = EXCLUDED.regulation_id
                RETURNING id
                """,
                (path_code, dept_id, type_id, addon_id, reg_id, curr_ver_id, total_credits)
            )
            path_id = cursor.fetchone()[0]
            path_db_map[path_code] = path_id
            
        print(f"  [OK] Seeded {len(path_db_map)} degree paths.")
        
        # 2. Path Bucket Requirements in batches of 100
        req_count = 0
        batch_size = 100
        for i in range(0, len(reqs_data), batch_size):
            chunk = reqs_data[i:i + batch_size]
            for r in chunk:
                path_code = r['Degree Path Code']
                bucket_code = r['Bucket Code']
                req_cred = r['Required Credits']
                
                path_id = path_db_map[path_code]
                bucket_id = bucket_map[bucket_code]
                
                cursor.execute(
                    """
                    INSERT INTO path_bucket_requirements (degree_path_id, bucket_id, required_credits, min_credits, is_mandatory)
                    VALUES (%s, %s, %s, %s, true)
                    ON CONFLICT (degree_path_id, bucket_id)
                    DO UPDATE SET required_credits = EXCLUDED.required_credits, min_credits = EXCLUDED.min_credits
                    """,
                    (path_id, bucket_id, req_cred, req_cred)
                )
                req_count += 1
            conn.commit()
            
        print(f"  [OK] Seeded {req_count} path bucket requirements.")
        
        # 3. Courses (CourseCatalog and CurriculumCourse)
        course_catalog_ids = {}
        curr_course_ids = {}
        
        for i in range(0, len(courses_data), batch_size):
            chunk = courses_data[i:i + batch_size]
            for c in chunk:
                code = c['Course Code']
                name = c['Course Name']
                l, t, p, s = c['L'], c['T'], c['P'], c['S']
                cr = c['Credits']
                prereq = c['Prerequisites']
                cat = c['Category']
                subcat = c['SubCategory']
                
                metadata = json.dumps({"L": l, "T": t, "P": p, "S": s, "prerequisites": prereq})
                
                cursor.execute(
                    """
                    INSERT INTO course_catalog (course_code, course_name, credits, category, metadata)
                    VALUES (%s, %s, %s, %s, %s::jsonb)
                    ON CONFLICT (course_code)
                    DO UPDATE SET course_name = EXCLUDED.course_name, credits = EXCLUDED.credits, metadata = EXCLUDED.metadata
                    RETURNING id
                    """,
                    (code, name, cr, cat, metadata)
                )
                cat_id = cursor.fetchone()[0]
                course_catalog_ids[code] = cat_id
                
                cursor.execute(
                    """
                    INSERT INTO curriculum_courses (curriculum_version_id, course_id, course_name, credits, lecture_hours, tutorial_hours, practical_hours, skill_hours, category, subcategory, prerequisite)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    ON CONFLICT (curriculum_version_id, course_id)
                    DO UPDATE SET course_name = EXCLUDED.course_name, credits = EXCLUDED.credits, subcategory = EXCLUDED.subcategory
                    RETURNING id
                    """,
                    (curr_ver_id, cat_id, name, cr, l, t, p, s, cat, subcat, prereq)
                )
                cc_id = cursor.fetchone()[0]
                curr_course_ids[code] = cc_id
            conn.commit()
            
        print(f"  [OK] Seeded {len(courses_data)} courses into CourseCatalog and CurriculumCourses.")
        
        # 4. Curriculum Course Mappings in batches
        map_count = 0
        for i in range(0, len(courses_data), batch_size):
            chunk = courses_data[i:i + batch_size]
            for c in chunk:
                code = c['Course Code']
                bucket_code = c['SubCategory']
                
                cc_id = curr_course_ids[code]
                bucket_id = bucket_map[bucket_code]
                
                cursor.execute(
                    """
                    INSERT INTO curriculum_course_mapping (curriculum_version_id, curriculum_course_id, bucket_id, mapping_source, mapping_confidence)
                    SELECT %s, %s, %s, 'OFFICIAL_PDF', 1.0
                    WHERE NOT EXISTS (
                        SELECT 1 FROM curriculum_course_mapping 
                        WHERE curriculum_version_id = %s AND curriculum_course_id = %s AND bucket_id = %s AND degree_path_id IS NULL
                    )
                    """,
                    (curr_ver_id, cc_id, bucket_id, curr_ver_id, cc_id, bucket_id)
                )
                
                cat_id = course_catalog_ids[code]
                cursor.execute(
                    """
                    INSERT INTO course_bucket_mapping (course_id, bucket_id, is_mandatory)
                    SELECT %s, %s, false
                    WHERE NOT EXISTS (
                        SELECT 1 FROM course_bucket_mapping WHERE course_id = %s AND bucket_id = %s AND degree_path_id IS NULL
                    )
                    """,
                    (cat_id, bucket_id, cat_id, bucket_id)
                )
                map_count += 1
            conn.commit()
            
        print(f"  [OK] Seeded {map_count} curriculum course mappings.")

    # Process CSE and AIDS
    process_dept('CSE', 'Y23-CSE', cse_paths, cse_reqs, cse_courses)
    process_dept('AIDS', 'Y23-AIDS', aids_paths, aids_reqs, aids_courses)
    
    conn.commit()
    print("\n========================================================")
    print("ALL Y23 CSE and Y23 AIDS Curriculum Data Seeded Successfully!")
    print("========================================================")
    cursor.close()
    conn.close()

if __name__ == "__main__":
    seed_database()
