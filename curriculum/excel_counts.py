import openpyxl

def count_rows(filename):
    wb = openpyxl.load_workbook(filename, read_only=True)
    sheet = wb.active
    # Count rows
    row_count = 0
    for row in sheet.iter_rows(values_only=True):
        if any(cell is not None for cell in row):
            row_count += 1
    return row_count - 1 # Subtract header

files = [
    r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\courses.xlsx",
    r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\requirements.xlsx",
    r"c:\Users\kteja\OneDrive\Desktop\Capstone\kl-academic-progress-tracking-system\curriculum\mappings.xlsx"
]

for f in files:
    print(f"{f}: {count_rows(f)} rows")
