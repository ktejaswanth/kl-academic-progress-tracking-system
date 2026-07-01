import requests
import json
import os

base_url = "http://localhost:8086"

def get_auth_token():
    login_data = {
        "username": "admin",
        "password": "password123"
    }
    res = requests.post(f"{base_url}/api/auth/login", json=login_data)
    if res.status_code != 200:
        raise Exception(f"Login failed: {res.text}")
    return res.json()['token']

def seed_buckets(headers):
    # Fetch existing buckets
    res = requests.get(f"{base_url}/api/dyod/master/buckets", headers=headers)
    if res.status_code != 200:
        raise Exception(f"Failed to fetch buckets: {res.text}")
    
    existing_bucket_codes = {b['bucketCode'] for b in res.json()}
    print(f"Found {len(existing_bucket_codes)} existing buckets in database.")
    
    # Define required buckets mapping
    required_buckets = {
        'FC-1': ('Flexi Core Course 1', 'Professional Core'),
        'FC-2': ('Flexi Core Course 2', 'Professional Core'),
        'HIC-CORE': ('Honors Innovation Core', 'Honors'),
        'HRC-CORE': ('Honors Research Core', 'Honors'),
        'SMFC-CORE': ('Second Major Flexi Core', 'Double Major'),
        'SMFC-SDP': ('Second Major Skill Development Program', 'Double Major'),
        'SIL-CORE': ('Self Initiated Learning Core', 'Self Learning'),
        'VAC-SPORTS': ('Value Added Course - Sports', 'Value Added'),
        'VAC-CERT': ('Value Added Course - Certification', 'Value Added'),
        'AUC-CORE': ('Audit Course - Core', 'Audit'),
        'AUC-CAREER': ('Audit Course - Career', 'Audit'),
        'BSC-ME-4': ('Basic Sciences - Mathematics Elective 4', 'Basic Sciences'),
        'BSC-ME-5': ('Basic Sciences - Mathematics Elective 5', 'Basic Sciences'),
        'VAC-': ('Value Added Course - Miscellaneous', 'Value Added'),
        'SMFC-': ('Second Major Flexi Core - Miscellaneous', 'Double Major'),
    }
    
    added_count = 0
    for code, (name, category) in required_buckets.items():
        if code not in existing_bucket_codes:
            body = {
                "bucketCode": code,
                "bucketName": name,
                "bucketCategory": category,
                "description": f"Seeded for B.Tech CSE Y23 curriculum - {name}"
            }
            res_post = requests.post(f"{base_url}/api/dyod/master/buckets", json=body, headers=headers)
            if res_post.status_code == 200 or res_post.status_code == 201:
                print(f"Successfully seeded bucket: {code}")
                added_count += 1
            else:
                print(f"Failed to seed bucket: {code}, error: {res_post.text}")
                
    print(f"Seeded {added_count} missing buckets.")

def seed_paths(headers):
    # Fetch existing paths
    res = requests.get(f"{base_url}/api/dyod/master/paths", headers=headers)
    if res.status_code != 200:
        raise Exception(f"Failed to fetch paths: {res.text}")
        
    existing_path_codes = {p['pathCode'] for p in res.json()}
    print(f"Found {len(existing_path_codes)} existing degree paths in database.")
    
    # 20 paths details with their required credit counts
    paths_definition = [
        ("HTE", "MINOR", 203),
        ("HTE", "DOUBLE_MAJOR", 208),
        ("HTE", "SPECIALIZATION", 193),
        ("HTE", "NONE", 183),
        ("HTI", "MINOR", 201),
        ("HTI", "DOUBLE_MAJOR", 208),
        ("HTI", "SPECIALIZATION", 193),
        ("HTI", "NONE", 183),
        ("HTR", "MINOR", 201),
        ("HTR", "DOUBLE_MAJOR", 208),
        ("HTR", "SPECIALIZATION", 193),
        ("HTR", "NONE", 183),
        ("HONORS", "MINOR", 201),
        ("HONORS", "DOUBLE_MAJOR", 208),
        ("HONORS", "SPECIALIZATION", 193),
        ("HONORS", "NONE", 183),
        ("REGULAR", "MINOR", 183),
        ("REGULAR", "DOUBLE_MAJOR", 188),
        ("REGULAR", "SPECIALIZATION", 168),
        ("REGULAR", "NONE", 163)
    ]
    
    added_count = 0
    for type_code, addon_code, total_credits in paths_definition:
        # Construct path code name
        path_code = f"CSE-{type_code}"
        if addon_code != "NONE":
            path_code += f"-{addon_code}"
            
        if path_code not in existing_path_codes:
            params = {
                "deptCode": "CSE",
                "typeCode": type_code,
                "addonCode": addon_code,
                "totalCredits": total_credits
            }
            res_post = requests.post(f"{base_url}/api/dyod/master/paths/generate", params=params, headers=headers)
            if res_post.status_code == 200 or res_post.status_code == 201:
                print(f"Successfully generated degree path: {path_code} ({total_credits} credits)")
                added_count += 1
            else:
                print(f"Failed to generate path: {path_code}, error: {res_post.text}")
                
    print(f"Generated {added_count} missing degree paths.")

def upload_excel_files(headers):
    # Paths to generated files
    courses_file = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\courses.xlsx"
    requirements_file = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\requirements.xlsx"
    mappings_file = r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\mappings.xlsx"
    
    # 1. Upload Courses
    print("\nUploading courses...")
    with open(courses_file, 'rb') as f:
        files = {'file': ('courses.xlsx', f, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')}
        res = requests.post(f"{base_url}/api/dyod/upload/courses", files=files, headers=headers)
        print("Courses Upload Status:", res.status_code)
        print("Courses Upload Response:", res.json())
        
    # 2. Upload Requirements
    print("\nUploading path requirements...")
    with open(requirements_file, 'rb') as f:
        files = {'file': ('requirements.xlsx', f, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')}
        res = requests.post(f"{base_url}/api/dyod/upload/requirements", files=files, headers=headers)
        print("Requirements Upload Status:", res.status_code)
        print("Requirements Upload Response:", res.json())
        
    # 3. Upload Course Bucket Mappings
    print("\nUploading course bucket mappings...")
    with open(mappings_file, 'rb') as f:
        files = {'file': ('mappings.xlsx', f, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')}
        res = requests.post(f"{base_url}/api/dyod/upload/mappings", files=files, headers=headers)
        print("Mappings Upload Status:", res.status_code)
        print("Mappings Upload Response:", res.json())

def main():
    print("Logging in to backend...")
    token = get_auth_token()
    headers = {"Authorization": f"Bearer {token}"}
    print("Authentication successful.")
    
    print("\nSeeding buckets...")
    seed_buckets(headers)
    
    print("\nSeeding paths...")
    seed_paths(headers)
    
    print("\nUploading Excel files...")
    upload_excel_files(headers)
    
    print("\nSeeding and upload process completed successfully!")

if __name__ == "__main__":
    main()
