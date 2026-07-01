import os
import re
import pandas as pd
import requests

# Configuration
base_url = "http://localhost:8086"
txt_path = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\Y23_BTech_AIDS_text.txt"
courses_out = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\aids_courses.xlsx"
reqs_out = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\aids_requirements.xlsx"
mappings_out = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\aids_mappings.xlsx"

valid_buckets = {
    'HAS-CORE', 'HAS-FLE', 'HAS-MGE', 'BSC-CORE', 'BSC-ME-1', 'BSC-ME-2', 'BSC-ME-3',
    'BSC-SE-1', 'BSC-SE-2', 'BSC-SE-3', 'ESC-CORE', 'PCC-CORE', 'FC-1', 'FC-2',
    'HFC-CORE', 'HEC-CORE', 'HRC-CORE', 'HIC-CORE', 'SDP-1', 'SDP-2', 'SDP-3', 'SDP-4',
    'PE-1', 'PE-2', 'PE-3', 'PE-4', 'PE-5', 'PRI-CORE', 'OE-1', 'OE-2', 'OE-3',
    'VAC-SPORTS', 'VAC-CERT', 'AUC-CORE', 'AUC-CAREER', 'SIL-CORE', 'MIN-CORE', 'MIN-SDP',
    'SMFC-CORE', 'SMFC-SDP'
}

def map_title_to_codes(title):
    title = re.sub(r"\s+", " ", title).strip()
    
    # Extract flexibility (type_code)
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
        
    # Extract addon (addon_code)
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
        
    dept_code = "AIDS"
    path_code = f"{dept_code}-{type_code}"
    if addon_code != "NONE":
        path_code += f"-{addon_code}"
        
    return type_code, addon_code, path_code

def map_bucket_category(code):
    if code.startswith('HAS'): return 'Humanities'
    if code.startswith('BSC'): return 'Basic Sciences'
    if code.startswith('ESC'): return 'Engineering Sciences'
    if code.startswith('PCC') or code.startswith('FC'): return 'Professional Core'
    if code.startswith('HF') or code.startswith('HE') or code.startswith('HR') or code.startswith('HI'): return 'Honors'
    if code.startswith('SDP') or code.startswith('SDC'): return 'Skill Development'
    if code.startswith('PE'): return 'Program Electives'
    if code.startswith('PRI'): return 'Project & Research'
    if code.startswith('OE'): return 'Open Electives'
    if code.startswith('MIN') or code.startswith('MSDC'): return 'Minor'
    if code.startswith('VAC'): return 'Value Added'
    if code.startswith('AUC'): return 'Audit'
    if code.startswith('SIL'): return 'Self Learning'
    if code.startswith('SMFC'): return 'Double Major'
    return 'Other'

def parse_curriculum():
    print("Parsing text from", txt_path)
    with open(txt_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    lines = content.split('\n')
    
    # 1. Parse Requirements
    print("Parsing requirements...")
    req_lines = lines[1339:2410]
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
            type_code, addon_code, path_code = map_title_to_codes(title)
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
            if len(parts) >= 7:
                if parts[0].isdigit() and parts[2] in valid_buckets:
                    sub_cat = parts[2]
                    min_cred = parts[3]
                    
                    requirements_rows.append({
                        'Degree Path Code': path_code,
                        'Bucket Code': sub_cat,
                        'Required Credits': int(float(min_cred))
                    })
                    
    # 2. Parse Courses
    print("Parsing courses...")
    # Preprocess hyphen-split lines in the entire file
    preprocessed_lines = []
    skip = False
    for i in range(len(lines)):
        if skip:
            skip = False
            continue
        line_clean = lines[i].strip()
        if line_clean.endswith('-') and i + 1 < len(lines):
            merged_line = line_clean + lines[i+1].strip()
            preprocessed_lines.append(merged_line + "\n")
            skip = True
        else:
            preprocessed_lines.append(lines[i])
            
    courses_dict = {}
    current_course = None
    accumulated_lines = []
    
    metrics_pattern = re.compile(r"^(.*?)\b([A-Z])\s+([^\s]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)(.*)$")
    
    valid_categories = {'HAS', 'BSC', 'ESC', 'PCC', 'FCC', 'HFC', 'HEC', 'HRC', 'HIC', 'SDC', 'PEC', 'PRI', 'OEC', 'VAC', 'AUC', 'SIL', 'MIN', 'MSDC', 'SMFC'}
    
    for line_idx, line in enumerate(preprocessed_lines):
        line_clean = line.strip()
        if not line_clean:
            continue
            
        parts = line_clean.split()
        if len(parts) >= 4 and parts[0].isdigit() and parts[1] in valid_categories:
            if current_course and current_course['code'] and any(char.isdigit() for char in current_course['code']):
                courses_dict[current_course['code']] = current_course
                
            cat = parts[1]
            
            # Determine if 3rd token is a course code (starts with digit)
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
            
            # Check immediately
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
            'Prerequisites': c['prereq'] if c['prereq'] else ""
        })
        mappings_rows.append({
            'Course Code': code,
            'Bucket Code': c['sub_category'],
            'Degree Path Code (Optional)': ""
        })
        
    df_courses = pd.DataFrame(courses_rows)
    df_reqs = pd.DataFrame(requirements_rows)
    df_mappings = pd.DataFrame(mappings_rows)
    
    df_courses.to_excel(courses_out, index=False)
    df_reqs.to_excel(reqs_out, index=False)
    df_mappings.to_excel(mappings_out, index=False)
    
    print(f"Generated Excel files:")
    print(f"1. Courses ({len(df_courses)} records): {courses_out}")
    print(f"2. Requirements ({len(df_reqs)} records): {reqs_out}")
    print(f"3. Mappings ({len(df_mappings)} records): {mappings_out}")
    
    return paths_data

def get_auth_token():
    login_data = {
        "username": "admin",
        "password": "password123"
    }
    res = requests.post(f"{base_url}/api/auth/login", json=login_data)
    if res.status_code != 200:
        raise Exception(f"Login failed: {res.text}")
    return res.json()['token']

def seed_missing_buckets(headers, req_df):
    print("\nFetching existing buckets...")
    res = requests.get(f"{base_url}/api/dyod/master/buckets", headers=headers)
    if res.status_code != 200:
        raise Exception(f"Failed to fetch buckets: {res.text}")
        
    existing_buckets = {b['bucketCode'] for b in res.json()}
    unique_req_buckets = set(req_df['Bucket Code'].unique())
    missing_buckets = unique_req_buckets - existing_buckets
    
    if not missing_buckets:
        print("All required buckets are already present.")
        return
        
    print(f"Found {len(missing_buckets)} missing buckets to seed: {missing_buckets}")
    for code in missing_buckets:
        category = map_bucket_category(code)
        body = {
            "bucketCode": code,
            "bucketName": f"{code} Course Bucket",
            "bucketCategory": category,
            "description": f"Dynamically seeded for Y23 AIDS curriculum"
        }
        res_post = requests.post(f"{base_url}/api/dyod/master/buckets", json=body, headers=headers)
        if res_post.status_code in (200, 201):
            print(f"Seeded bucket: {code}")
        else:
            print(f"Failed to seed bucket: {code}, error: {res_post.text}")

def seed_aids_paths(headers, paths_data):
    print("\nChecking degree paths...")
    res = requests.get(f"{base_url}/api/dyod/master/paths", headers=headers)
    if res.status_code != 200:
        raise Exception(f"Failed to fetch paths: {res.text}")
        
    existing_paths = {p['pathCode'] for p in res.json()}
    
    added_count = 0
    for p in paths_data:
        path_code = p['path_code']
        type_code = p['type_code']
        addon_code = p['addon_code']
        total_credits = p['total_credits']
        
        if path_code not in existing_paths:
            params = {
                "deptCode": "AIDS",
                "typeCode": type_code,
                "addonCode": addon_code,
                "totalCredits": total_credits
            }
            res_post = requests.post(f"{base_url}/api/dyod/master/paths/generate", params=params, headers=headers)
            if res_post.status_code in (200, 201):
                print(f"Generated degree path: {path_code} ({total_credits} credits)")
                added_count += 1
            else:
                print(f"Failed to generate path: {path_code}, error: {res_post.text}")
                
    print(f"Generated {added_count} new degree paths for AIDS.")

def upload_excel_files(headers):
    # 1. Upload Courses
    print("\nUploading courses...")
    with open(courses_out, 'rb') as f:
        files = {'file': ('aids_courses.xlsx', f, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')}
        res = requests.post(f"{base_url}/api/dyod/upload/courses", files=files, headers=headers)
        print("Courses Upload Status:", res.status_code)
        print("Courses Upload Response:", res.json())
        
    # 2. Upload Requirements
    print("\nUploading path requirements...")
    with open(reqs_out, 'rb') as f:
        files = {'file': ('aids_requirements.xlsx', f, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')}
        res = requests.post(f"{base_url}/api/dyod/upload/requirements", files=files, headers=headers)
        print("Requirements Upload Status:", res.status_code)
        print("Requirements Upload Response:", res.json())
        
    # 3. Upload Course Bucket Mappings
    print("\nUploading course bucket mappings...")
    with open(mappings_out, 'rb') as f:
        files = {'file': ('aids_mappings.xlsx', f, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')}
        res = requests.post(f"{base_url}/api/dyod/upload/mappings", files=files, headers=headers)
        print("Mappings Upload Status:", res.status_code)
        print("Mappings Upload Response:", res.json())

def main():
    paths_data = parse_curriculum()
    
    print("\nLogging in to backend...")
    token = get_auth_token()
    headers = {"Authorization": f"Bearer {token}"}
    print("Authentication successful.")
    
    req_df = pd.read_excel(reqs_out)
    seed_missing_buckets(headers, req_df)
    seed_aids_paths(headers, paths_data)
    upload_excel_files(headers)
    
    print("\nAll seeding and upload operations completed successfully for AIDS department!")

if __name__ == "__main__":
    main()
