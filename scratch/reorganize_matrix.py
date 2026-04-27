import csv

file_path = '/home/mohamed/barbarous/docs/matrix.csv'
output_file = '/home/mohamed/barbarous/docs/matrix_reorganized.csv'

# Mapping of apps to their new categories
reorg_map = {
    'discordo': 'Networking & Internet',
    'jrnl': 'Text & Search Tools',
    'taproom': 'Development Git & Containers',
    'fastfetch': 'System Management & Monitoring',
    'neofetch': 'System Management & Monitoring'
}

with open(file_path, mode='r', newline='') as f:
    reader = csv.reader(f)
    header = next(reader)
    rows = list(reader)

new_rows = []
for row in rows:
    app_name = row[1]
    if app_name in reorg_map:
        row[0] = reorg_map[app_name]
    new_rows.append(row)

# Sort by Category to keep it clean (optional but good practice)
# new_rows.sort(key=lambda x: x[0]) 
# Actually, better to keep the relative order within categories if possible, 
# but a full sort might be better for consistency.

with open(output_file, mode='w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerows(new_rows)
