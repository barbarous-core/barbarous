import csv
import re

md_file = '/home/mohamed/barbarous/docs/Barbarous_Core_CLI.md'
csv_file = '/home/mohamed/barbarous/docs/matrix.csv'
output_file = '/home/mohamed/barbarous/docs/matrix_with_desc.csv'

# Step 1: Extract descriptions from Markdown
descriptions = {}
# Regex for markdown table rows: | **App** | Description | ... |
# We need to handle cases where there might be spaces or stars
# | **bat** | A `cat` clone with syntax highlighting and Git integration. | ... |
table_row_pattern = re.compile(r'^\|\s*\*\*(.*?)\*\*(?:\s*\*(?:added|modified)\*)?\s*\|\s*(.*?)\s*\|')

with open(md_file, 'r') as f:
    for line in f:
        match = table_row_pattern.match(line)
        if match:
            app_name = match.group(1).strip()
            desc = match.group(2).strip()
            # Handle cases like "ripgrep (rg)" vs "ripgrep"
            descriptions[app_name] = desc

# Step 2: Update CSV
with open(csv_file, mode='r', newline='') as f:
    reader = csv.reader(f)
    header = next(reader)
    
    # Add Description to header (3rd column)
    new_header = header[:2] + ['Description'] + header[2:]
    
    rows = []
    for row in reader:
        if not row:
            continue
        app_name = row[1]
        # Match description
        desc = descriptions.get(app_name, "N/A")
        
        # Fallback for slight mismatches
        if desc == "N/A":
            # Check for partial matches or stripped names
            for key in descriptions:
                if key.lower() == app_name.lower():
                    desc = descriptions[key]
                    break
        
        new_row = row[:2] + [desc] + row[2:]
        rows.append(new_row)

# Step 3: Write Output
with open(output_file, mode='w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(new_header)
    writer.writerows(rows)
