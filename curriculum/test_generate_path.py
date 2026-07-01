import requests
base_url = "http://localhost:8086"
login_data = {"username": "admin", "password": "password123"}
token = requests.post(f"{base_url}/api/auth/login", json=login_data).json()['token']
headers = {"Authorization": f"Bearer {token}"}
params = {
    "deptCode": "CSE",
    "typeCode": "HTE",
    "addonCode": "MINOR",
    "totalCredits": 203
}
res = requests.post(f"{base_url}/api/dyod/master/paths/generate", params=params, headers=headers)
print("Status Code:", res.status_code)
print("Response text:", res.text)
