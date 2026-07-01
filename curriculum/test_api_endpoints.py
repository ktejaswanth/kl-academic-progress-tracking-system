import requests

base_url = "http://localhost:8086"

# 1. Login as Admin
print("1. Logging in as Admin...")
admin_res = requests.post(f"{base_url}/api/auth/login", json={"username": "admin", "password": "password123"})
print("Admin Login status:", admin_res.status_code)
if admin_res.status_code != 200:
    print("Failed to login as admin")
    exit(1)
admin_token = admin_res.json()["token"]
admin_headers = {"Authorization": f"Bearer {admin_token}"}

# 2. Auto-assign all student paths
print("\n2. Auto-assigning paths /api/dyod/paths/auto-assign-all...")
assign_res = requests.post(f"{base_url}/api/dyod/paths/auto-assign-all", headers=admin_headers)
print("Auto-assign status:", assign_res.status_code)
print("Auto-assign output:", assign_res.json() if assign_res.status_code == 200 else assign_res.text)

# 3. Batch evaluate all progress
print("\n3. Batch evaluating all progress /api/dyod/progress/batch-evaluate...")
evaluate_res = requests.post(f"{base_url}/api/dyod/progress/batch-evaluate", headers=admin_headers)
print("Batch evaluate status:", evaluate_res.status_code)
print("Batch evaluate output:", evaluate_res.json() if evaluate_res.status_code == 200 else evaluate_res.text)

# 4. Login as Student
print("\n4. Logging in as student 2100030001...")
student_res = requests.post(f"{base_url}/api/auth/login", json={"username": "2100030001", "password": "password123"})
print("Student Login status:", student_res.status_code)
if student_res.status_code != 200:
    print("Failed to login as student")
    exit(1)
student_token = student_res.json()["token"]
student_headers = {"Authorization": f"Bearer {student_token}"}

# 5. Fetch Profile
print("\n5. Fetching profile /api/student/profile...")
profile_res = requests.get(f"{base_url}/api/student/profile", headers=student_headers)
print("Profile status:", profile_res.status_code)
print("Profile content:", profile_res.json())

# 6. Fetch Progress
print("\n6. Fetching progress /api/dyod/progress/student/me...")
progress_res = requests.get(f"{base_url}/api/dyod/progress/student/me", headers=student_headers)
print("Progress status:", progress_res.status_code)
print("Progress content keys:", list(progress_res.json().keys()) if progress_res.status_code == 200 else progress_res.text)
if progress_res.status_code == 200:
    print("Buckets detail count:", len(progress_res.json().get("buckets", [])))
    print("Overall status:", progress_res.json().get("status", {}).get("status"))

# 7. Fetch Completed Courses
print("\n7. Fetching completed courses /api/dyod/courses/student/me...")
courses_res = requests.get(f"{base_url}/api/dyod/courses/student/me", headers=student_headers)
print("Completed courses status:", courses_res.status_code)
print("Completed courses count:", len(courses_res.json()) if isinstance(courses_res.json(), list) else courses_res.json())

# 8. Fetch Student Report
print("\n8. Fetching report /api/reports/student/me...")
report_res = requests.get(f"{base_url}/api/reports/student/me", headers=student_headers)
print("Report status:", report_res.status_code)
print("Report summary keys:", list(report_res.json().keys()) if report_res.status_code == 200 else report_res.text)
