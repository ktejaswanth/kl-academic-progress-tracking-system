import os

p = "temp_log.txt"
if os.path.exists(p):
    size = os.path.getsize(p)
    print(f"Size: {size} bytes")
    with open(p, 'rb') as f:
        content = f.read()
        print(f"Read {len(content)} bytes")
        last_bytes = content[-1000:]
        print("Last bytes:")
        print(last_bytes.decode('utf-8', errors='ignore'))
else:
    print("temp_log.txt does not exist")
