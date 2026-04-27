import csv

file_path = '/home/mohamed/barbarous/docs/matrix.csv'
rows = []

with open(file_path, mode='r', newline='') as f:
    reader = csv.reader(f)
    rows = list(reader)

# Find where to insert mpv (after ffmpeg-free)
new_rows = []
inserted = False
for row in rows:
    new_rows.append(row)
    if row[1] == 'ffmpeg-free' and not inserted:
        new_rows.append(['Media Extras & Fun', 'mpv', 'rpm', 'cli', 'x', 'x', 'x', 'x', 'x', 'x'])
        inserted = True

with open(file_path, mode='w', newline='') as f:
    writer = csv.writer(f)
    writer.writerows(new_rows)
