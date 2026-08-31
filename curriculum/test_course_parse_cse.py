import re
import pandas as pd

txt_path = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\Y23_BTech_CSE_text.txt"

def test_course_parse():
    with open(txt_path, 'r', encoding='utf-8') as f:
        content = f.read()
    lines = content.split('\n')
    
    # Restrict to Program Structure range
    structure_lines = lines[2413:9719]
    
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
    
    for line_idx, line in enumerate(preprocessed_lines):
        line_clean = line.strip()
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

    print(f"Total distinct courses parsed for CSE: {len(courses_dict)}")
    none_titles = [c for c in courses_dict.values() if not c['title']]
    print(f"Courses with None title: {len(none_titles)}")
    for code in list(courses_dict.keys())[:15]:
        c = courses_dict[code]
        print(f"{c['code']}: {c['title']} ({c['sub_category']}) - {c['credits']} Cr (L:{c['L']}, T:{c['T']}, P:{c['P']}, S:{c['S']})")

if __name__ == "__main__":
    test_course_parse()
