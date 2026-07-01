import sys

def tail(filename, n=50):
    try:
        with open(filename, 'r', encoding='utf-8', errors='ignore') as f:
            lines = f.readlines()
            for line in lines[-n:]:
                print(line, end='')
    except Exception as e:
        print("Error reading file:", e)

if __name__ == '__main__':
    filename = sys.argv[1] if len(sys.argv) > 1 else r"C:\Users\kteja\.gemini\antigravity-ide\brain\84bfaab9-82a4-4983-b01c-6a546861a2d2\.system_generated\tasks\task-1204.log"
    tail(filename)
