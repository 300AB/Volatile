# split_html_quick.py
import os

# Configuration
char_limit = 24000
input_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'chat_export.html')
base_name = 'chat_export_full_part'

# Read full HTML
with open(input_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Split into chunks
parts = [content[i:i+char_limit] for i in range(0, len(content), char_limit)]

# Write chunks
output_paths = []
for idx, part in enumerate(parts, 1):
    out_file = os.path.join(os.path.dirname(input_file), f"{base_name}{idx}.html")
    with open(out_file, 'w', encoding='utf-8') as f:
        f.write(part)
    output_paths.append(out_file)
    print(f"Wrote {out_file} ({len(part)} chars)")

print(f"\nTotal parts created: {len(parts)}")
