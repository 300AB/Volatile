import re
import json

input_file = './target.filter'   # change to your input file
output_file = './color-list-output.json'

def parse_color_line(line: str):
    """
    Parse lines like 'SetBackgroundColor 40 40 0 169'
    → (label, rgb/rgba string).
    """
    pattern = re.compile(r"^Set(\w+)\s+(\d+)\s+(\d+)\s+(\d+)(?:\s+(\d+))?$")
    match = pattern.match(line.strip())
    if not match:
        return None, None

    label, r, g, b, a = match.groups()
    r, g, b = int(r), int(g), int(b)

    if a is None:
        return label, f"rgb({r}, {g}, {b})"
    else:
        a = int(a)
        alpha = round(a / 255, 3) if a > 1 else a
        return label, f"rgba({r}, {g}, {b}, {alpha})"

def main():
    colors = {}
    with open(input_file, "r", encoding="utf-8") as f:
        for line in f:
            label, color = parse_color_line(line)
            if label and color:
                colors[label] = color

    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(colors, f, indent=2)

    print(f"Exported {len(colors)} colors → {output_file}")

if __name__ == "__main__":
    main()
