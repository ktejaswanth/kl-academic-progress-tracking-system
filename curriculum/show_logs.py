import os

def main():
    p = "temp_log.txt"
    if os.path.exists(p):
        print(f"Reading {p}...")
        with open(p, 'r', encoding='utf-8', errors='ignore') as f:
            lines = f.readlines()
        print(f"Total lines: {len(lines)}")
        first_err_idx = -1
        for idx, line in enumerate(lines):
            if "ERROR" in line or "Exception" in line:
                if "transaction is aborted" not in line and "Connection is closed" not in line and "PoolBase" not in line:
                    first_err_idx = idx
                    break
        if first_err_idx != -1:
            print(f"First interesting error found at line {first_err_idx}:")
            start = max(0, first_err_idx - 5)
            end = min(len(lines), first_err_idx + 15)
            for k in range(start, end):
                print(f"  {k}: {lines[k].strip()}")
        else:
            print("No interesting error/exception found in log.")
    else:
        print("temp_log.txt does not exist")

if __name__ == "__main__":
    main()
