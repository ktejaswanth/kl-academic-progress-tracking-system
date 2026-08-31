import re
import socket
import ssl
import json
import pg8000

def parse_specializations():
    with open('curriculum/Y23_BTech_AIDS_text.txt', 'r', encoding='utf-8', errors='ignore') as f:
        text = f.read()

    pattern = r'(\d+\.\s+SPECIALIZATION:\s+([^\n\r]+))'
    splits = list(re.finditer(pattern, text))
    print(f"Found {len(splits)} specialization sections in AIDS PDF text.")

    specs = []
    for idx, match in enumerate(splits):
        spec_name = match.group(2).strip().rstrip('?')
        start_pos = match.end()
        end_pos = splits[idx+1].start() if idx+1 < len(splits) else start_pos + 15000
        block = text[start_pos:end_pos]
        
        # Extract all courses
        # Regex to match course line: e.g. 1 SDC SDP-4 23SDCI05A CLOUD DEVOPS A CDP 0 0 6 4 4 10
        # or 4 PEC PE-1 23SMD3101A SOFTWARE VERIFICATION & VALIDATION A SVV 4 0 4 4 7 12
        courses = []
        lines = block.splitlines()
        for i, line in enumerate(lines):
            m = re.search(r'\b(23[A-Z0-9]{5,9}[A-Z]?)\b', line)
            if m:
                code = m.group(1)
                # Look for bucket subcategory like PE-1, PE-2, SDP-4, etc.
                bucket_m = re.search(r'\b(PE-[1-5]|SDP-[1-4]|OE-[1-3]|PCC)\b', line)
                bucket = bucket_m.group(1) if bucket_m else "PE"
                
                # Try to get course title
                # Usually after course code or around it
                rest = line[m.end():].strip()
                # Remove trailing numbers / modes if present
                title = re.sub(r'\s+[AERM]\s+[A-Z0-9\-\/]+\s+\d+.*$', '', rest)
                if not title or len(title) < 3:
                    # check next line
                    if i + 1 < len(lines):
                        title = lines[i+1].strip()
                courses.append({
                    "course_code": code,
                    "bucket": bucket,
                    "title": title
                })
        
        # Deduplicate courses by course_code
        unique_courses = []
        seen = set()
        for c in courses:
            if c["course_code"] not in seen:
                seen.add(c["course_code"])
                unique_courses.append(c)

        # Generate a slug/code for specialization
        code_slug = re.sub(r'[^A-Z0-9]+', '-', spec_name.upper()).strip('-')
        specs.append({
            "name": spec_name,
            "code": code_slug,
            "courses": unique_courses
        })

    return specs

def main():
    specs = parse_specializations()
    print(f"\nSuccessfully parsed {len(specs)} specializations.")
    for s in specs[:5]:
        print(f"\nSpec: {s['name']} (Code: {s['code']}) -> {len(s['courses'])} courses:")
        for c in s['courses'][:4]:
            print(f"  - {c['course_code']} [{c['bucket']}]: {c['title']}")

    with open('curriculum/aids_specializations_parsed.json', 'w', encoding='utf-8') as f:
        json.dump(specs, f, indent=2)
    print("\nWrote curriculum/aids_specializations_parsed.json")

if __name__ == "__main__":
    main()
