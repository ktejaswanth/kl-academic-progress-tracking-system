import re
import pandas as pd

txt_path = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\Y23_BTech_CSE_text.txt"

valid_buckets = {
    'HAS-CORE', 'HAS-FLE', 'HAS-MGE', 'BSC-CORE', 'BSC-ME-1', 'BSC-ME-2', 'BSC-ME-3',
    'BSC-ME-4', 'BSC-ME-5', 'BSC-SE-1', 'BSC-SE-2', 'BSC-SE-3', 'ESC-CORE', 'PCC-CORE', 'FC-1', 'FC-2',
    'HFC-CORE', 'HEC-CORE', 'HRC-CORE', 'HIC-CORE', 'SDP-1', 'SDP-2', 'SDP-3', 'SDP-4',
    'PE-1', 'PE-2', 'PE-3', 'PE-4', 'PE-5', 'PRI-CORE', 'OE-1', 'OE-2', 'OE-3',
    'VAC-SPORTS', 'VAC-CERT', 'AUC-CORE', 'AUC-CAREER', 'SIL-CORE', 'MIN-CORE', 'MIN-SDP',
    'SMFC-CORE', 'SMFC-SDP'
}

def map_title_to_codes(title):
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
        
    dept_code = "CSE"
    path_code = f"{dept_code}-{type_code}"
    if addon_code != "NONE":
        path_code += f"-{addon_code}"
        
    return type_code, addon_code, path_code

def test_parse():
    with open(txt_path, 'r', encoding='utf-8') as f:
        content = f.read()
    lines = content.split('\n')
    
    req_lines = lines[1320:2412]
    req_content = '\n'.join(req_lines)
    sections = re.split(r"\n(?=\d+\.\s+(?:Honors|No Flexibility))", req_content)
    
    print(f"Total sections found: {len(sections)}")
    paths = []
    total_req_rows = 0
    
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
        except ValueError as e:
            print(f"Error mapping title: {title}: {e}")
            continue
        total_credit_match = re.search(r"Total Credit Required:\s*(\d+)", sect, re.IGNORECASE)
        total_credits = int(total_credit_match.group(1)) if total_credit_match else 0
        
        req_count = 0
        sum_credits = 0
        for line in sect_lines:
            parts = line.strip().split()
            if len(parts) >= 7 and parts[0].isdigit() and parts[2] in valid_buckets:
                sub_cat = parts[2]
                min_cred = int(float(parts[3]))
                req_count += 1
                sum_credits += min_cred
                
        paths.append({
            'index': index_str,
            'title': title,
            'path_code': path_code,
            'type_code': type_code,
            'addon_code': addon_code,
            'total_credits': total_credits,
            'sum_credits': sum_credits,
            'req_count': req_count
        })
        total_req_rows += req_count
        
    print("\n--- Parsed 20 CSE Paths ---")
    for p in paths:
        print(f"{p['index']}. {p['path_code']}: Total={p['total_credits']}, SumMinCred={p['sum_credits']}, Buckets={p['req_count']}")
        
    print(f"\nTotal requirements rows: {total_req_rows}")

if __name__ == "__main__":
    test_parse()
