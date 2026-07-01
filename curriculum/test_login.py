import requests

base_url = "http://localhost:8086"
login_data = {
    "username": "admin",
    "password": "password123"
}

res = requests.post(f"{base_url}/api/auth/login", json=login_data)
print("Status Code:", res.status_code)
print("Response JSON:", res.json())
