import csv

input_file = '/home/mohamed/barbarous/docs/matrix.csv'
output_file = '/home/mohamed/barbarous/docs/matrix_updated.csv'

with open(input_file, mode='r', newline='') as infile:
    reader = csv.reader(infile)
    header = next(reader)
    
    # Add AppType to header
    new_header = header[:3] + ['AppType'] + header[3:]
    
    rows = []
    for row in reader:
        if not row:
            continue
        # Default to 'cli' for these tools
        app_type = 'cli'
        
        # Specific overrides if any (none currently identified as pure GUI in this list)
        if row[1].lower() == 'cockpit':
            app_type = 'gui' # Web GUI
            
        new_row = row[:3] + [app_type] + row[3:]
        rows.append(new_row)

with open(output_file, mode='w', newline='') as outfile:
    writer = csv.writer(outfile)
    writer.writerow(new_header)
    writer.writerows(rows)
