import csv
import json
import os

def generate_assets_jsons(csv_path):
    if not os.path.exists(csv_path):
        print(f"Error: {csv_path} not found.")
        return

    with open(csv_path, 'r') as f:
        reader = csv.DictReader(f)
        data = list(reader)

    # Get edition columns (everything except File and Type)
    editions = [col for col in reader.fieldnames if col not in ['File', 'Type']]
    
    for edition in editions:
        assets = {
            "bin": [],
            "rpm": [],
            "dotfile": []
        }
        
        for row in data:
            if row[edition].lower() == 'x':
                t_type = row['Type'].lower()
                if t_type in assets:
                    assets[t_type].append(row['File'])
                else:
                    # If type is unknown, we could skip or add to a generic list
                    pass
        
        # Define output path: editions/<edition_lower>/assets.json
        output_dir = os.path.join('editions', edition.lower())
        os.makedirs(output_dir, exist_ok=True)
        output_path = os.path.join(output_dir, 'assets.json')
        
        with open(output_path, 'w') as f:
            json.dump(assets, f, indent=2)
        
        print(f"Generated {output_path}")

if __name__ == "__main__":
    generate_assets_jsons('docs/matrix.csv')
