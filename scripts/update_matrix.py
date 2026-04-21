import csv
import re
import os

def parse_md_to_csv(md_path, csv_path):
    with open(md_path, 'r') as f:
        lines = f.readlines()

    tools = []
    # Integration Method Mapping
    mapping = {
        'Bin Injected': 'bin',
        'Bin Injected/Plugin': 'bin',
        'Layered': 'rpm',
        'Layered (Kmod)': 'rpm',
        'Layered/Plugin': 'rpm',
        'default 43': 'rpm',
        'Home Dir Setup': 'dotfile',
        'Container': 'bin',
        'Container/Layered': 'rpm',
        'Container/Pip': 'bin',
        'Layered / Bin': 'bin', # Or rpm? Let's check rclone. Usually bin if they want speed.
    }

    in_table = False
    for line in lines:
        line = line.strip()
        if line.startswith('|') and 'Application' in line:
            in_table = True
            continue
        if in_table:
            if not line.startswith('|'):
                in_table = False
                continue
            if '---' in line:
                continue
            
            parts = [p.strip() for p in line.split('|')]
            if len(parts) < 4:
                continue
            
            app_raw = parts[1]
            # Remove bolding **app** and (added)
            app = re.sub(r'\*\*|\*', '', app_raw)
            app = re.sub(r'\(added\)', '', app).strip()
            
            method = parts[3].strip()
            
            tool_type = 'unknown'
            for key, val in mapping.items():
                if key in method:
                    tool_type = val
                    break
            
            if tool_type == 'unknown':
                if method and method != 'Integration Method':
                    # Default to rpm if it's layered-like or bin if it's injected-like
                    if 'Layered' in method or 'dnf' in line:
                        tool_type = 'rpm'
                    else:
                        tool_type = 'bin'
            
            if app and tool_type != 'unknown' and app != 'Application':
                tools.append({
                    'File': app,
                    'Type': tool_type,
                    'Core': 'x',
                    'Station': 'x',
                    'Studio': 'x',
                    'Edge': 'x',
                    'Lab': 'x',
                    'Touch': 'x'
                })

    # Write to CSV
    fieldnames = ['File', 'Type', 'Core', 'Station', 'Studio', 'Edge', 'Lab', 'Touch']
    with open(csv_path, 'w', newline='') as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(tools)

if __name__ == "__main__":
    parse_md_to_csv('docs/Barbarous_Core_CLI.md', 'docs/matrix.csv')
