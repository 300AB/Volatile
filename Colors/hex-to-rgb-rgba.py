import json
import re
import os

# Auto-detect script directory
script_dir = os.path.dirname(os.path.abspath(__file__))
input_file = os.path.join(script_dir, "hex_colors.json")
output_file = os.path.join(script_dir, "palette_import.json")

def hex_to_rgb(hex_color):
    hex_color = hex_color.lstrip('#')
    if len(hex_color) == 3:
        hex_color = ''.join([c*2 for c in hex_color])
    r = int(hex_color[0:2], 16)
    g = int(hex_color[2:4], 16)
    b = int(hex_color[4:6], 16)
    return r, g, b

def main():
    if not os.path.exists(input_file):
        print(f"Input file not found: {input_file}")
        return

    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    output = []
    seen = set()

    for hex_color in data:
        hex_color = hex_color.strip().lower()
        if not re.match(r'^#([0-9a-f]{3}|[0-9a-f]{6})$', hex_color):
            print(f"Skipping invalid hex: {hex_color}")
            continue
        if hex_color in seen:
            continue
        seen.add(hex_color)

        r, g, b = hex_to_rgb(hex_color)
        rgb_str = f"rgb({r},{g},{b})"
        rgba_str = f"rgba({r},{g},{b},1)"
        output.extend([hex_color, rgb_str, rgba_str])

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(output, f, indent=2)

    print(f"Converted {len(seen)} colors to import-ready JSON at {output_file}")

if __name__ == "__main__":
    main()
