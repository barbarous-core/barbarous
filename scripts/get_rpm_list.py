import json
import os

def get_rpms_from_assets():
    assets_path = 'editions/core/assets.json'
    if not os.path.exists(assets_path):
        return []
    
    with open(assets_path, 'r') as f:
        assets = json.load(f)
    
    return assets.get('rpm', [])

if __name__ == "__main__":
    rpms = get_rpms_from_assets()
    print(" ".join(rpms))
