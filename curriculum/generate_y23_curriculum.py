import re
import pandas as pd

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
        
    dept_code = "CSE"
    path_code = f"{dept_code}-{type_code}"
    if addon_code != "NONE":
        path_code += f"-{addon_code}"
        
    return type_code, addon_code, path_code

def parse_requirements():
    txt_path = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\page_30_to_70_text.txt"
    with open(txt_path, 'r', encoding='utf-8') as f:
        content = f.read()
        
    sections = re.split(r"\n(?=\d+\.\s+(?:Honors|No Flexibility))", content)
    
    requirements_rows = []
    paths_data = []
    
    for sect in sections:
        lines = sect.strip().split('\n')
        if not lines:
            continue
        header = lines[0]
        # Match header line like "1. Honors through Experiential Learning with Minor"
        match_header = re.match(r"^(\d+)\.\s+([^\n]+)", header)
        if not match_header:
            continue
            
        index_str, title = match_header.groups()
        try:
            type_code, addon_code, path_code = map_title_to_codes(title)
        except ValueError as e:
            # Skip page 1 (list of combinations)
            continue
            
        total_credit_match = re.search(r"Total Credit Required:\s*(\d+)", sect, re.IGNORECASE)
        total_credits = int(total_credit_match.group(1)) if total_credit_match else 0
        
        paths_data.append({
            'path_code': path_code,
            'type_code': type_code,
            'addon_code': addon_code,
            'total_credits': total_credits
        })
        
        for line in lines:
            m = re.match(r"^(\d+)\s+([A-Z0-9\-]+)\s+([A-Z0-9\-]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)(.*)$", line.strip())
            if m:
                _, _, sub_cat, min_cred, _, _, _, _ = m.groups()
                requirements_rows.append({
                    'Degree Path Code': path_code,
                    'Bucket Code': sub_cat,
                    'Required Credits': int(min_cred)
                })
                
    return pd.DataFrame(paths_data), pd.DataFrame(requirements_rows)

def parse_courses_from_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    # Preprocess hyphen-split lines
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
            
    lines = preprocessed_lines
    
    courses_dict = {}
    current_course = None
    accumulated_lines = []
    
    start_pattern = re.compile(r"^(\d+)\s+([A-Z0-9\-]+)\s+([A-Z0-9\-]+)\s+(23[A-Z0-9_]{3,12})(.*)$")
    metrics_pattern = re.compile(r"^(.*?)\b([A-Z])\s+([^\s]+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)(.*)$")
    
    for line_idx, line in enumerate(lines):
        line_clean = line.strip()
        if not line_clean:
            continue
            
        start_match = start_pattern.match(line_clean)
        if start_match:
            if current_course:
                # Save previous incomplete course if any
                courses_dict[current_course['code']] = current_course
                
            s_num, cat, sub_cat, code, rest = start_match.groups()
            current_course = {
                'code': code,
                'sub_category': sub_cat,
                'title': None,
                'L': 0, 'T': 0, 'P': 0, 'S': 0, 'credits': 0.0,
                'prereq': ''
            }
            rest_clean = rest.strip()
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
                
                courses_dict[current_course['code']] = current_course
                current_course = None
                accumulated_lines = []
                
    if current_course:
        courses_dict[current_course['code']] = current_course
        
    return courses_dict

def main():
    print("Parsing requirements...")
    df_paths, df_reqs = parse_requirements()
    print(f"Parsed {len(df_paths)} paths and {len(df_reqs)} requirements.")
    
    print("Parsing courses...")
    file1 = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\page_71_to_131_text.txt"
    file2 = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\page_132_to_213_text.txt"
    
    courses1 = parse_courses_from_file(file1)
    courses2 = parse_courses_from_file(file2)
    
    # Merge courses, file 2 (minor/spec) overrides or merges with file 1
    all_courses = {}
    all_courses.update(courses1)
    all_courses.update(courses2)
    
    print(f"Total unique courses extracted: {len(all_courses)}")
    
    # Generate courses list
    courses_rows = []
    mappings_rows = []
    
    for code, c in all_courses.items():
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
            'Degree Path Code (Optional)': "" # universal mapping
        })
        
    df_courses = pd.DataFrame(courses_rows)
    df_mappings = pd.DataFrame(mappings_rows)
    
    # Write to Excel files in the curriculum folder
    courses_out = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\courses.xlsx"
    reqs_out = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\requirements.xlsx"
    mappings_out = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\mappings.xlsx"
    
    df_courses.to_excel(courses_out, index=False)
    df_reqs.to_excel(reqs_out, index=False)
    df_mappings.to_excel(mappings_out, index=False)
    
    print("Excel files generated successfully:")
    print(f"1. Courses: {courses_out}")
    print(f"2. Requirements: {reqs_out}")
    print(f"3. Mappings: {mappings_out}")

if __name__ == "__main__":
    main()
