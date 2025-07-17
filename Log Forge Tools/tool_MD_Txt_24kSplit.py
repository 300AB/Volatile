import os

# Base path relative to the script itself
script_dir = os.path.dirname(os.path.abspath(__file__))

# Ask user which input to split
choice = ''
while choice not in ['md', 'txt']:
    choice = input("Which input to split? Type 'md' for markdown or 'txt' for plaintext: ").strip().lower()

if choice == 'md':
    input_file = os.path.join(script_dir, 'output_md', 'chat_export_full.md')
elif choice == 'txt':
    input_file = os.path.join(script_dir, 'output_txt', 'chat_export_full.txt')

# Base name for output files (without folder)
base_name = 'chat_export_full_part'

# Output directory for split parts (keep consistent with input type)
output_dir = os.path.join(script_dir, f'output_{choice}', 'splits_' + choice)
os.makedirs(output_dir, exist_ok=True)

char_limit = 24000

def split_md_file(filepath, base_output_dir, base_output_name, limit=24000, strip_md=False):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    # Use your separator for both md and txt
    blocks = content.split('\n---\n\n')

    current_part = 1
    current_text = ''
    output_paths = []

    for block in blocks:
        block_with_sep = block.strip() + '\n\n---\n\n'

        if len(current_text) + len(block_with_sep) > limit:
            part_ext = 'txt' if strip_md else 'md'
            part_file = os.path.join(base_output_dir, f"{base_output_name}{current_part}.{part_ext}")
            with open(part_file, 'w', encoding='utf-8') as out:
                out.write(current_text.strip())
            output_paths.append(part_file)
            current_part += 1
            current_text = ''

        if strip_md:
            lines = block_with_sep.splitlines()
            stripped = []
            in_code = False
            for line in lines:
                if line.strip().startswith('```'):
                    in_code = not in_code
                    continue
                if not in_code and line.strip().startswith('###'):
                    continue
                stripped.append(line)
            block_with_sep = '\n'.join(stripped).strip() + '\n\n---\n\n'

        current_text += block_with_sep

    if current_text.strip():
        part_ext = 'txt' if strip_md else 'md'
        part_file = os.path.join(base_output_dir, f"{base_output_name}{current_part}.{part_ext}")
        with open(part_file, 'w', encoding='utf-8') as out:
            out.write(current_text.strip())
        output_paths.append(part_file)

    return output_paths


def print_stats(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
    chars = len(content)
    lines = content.count('\n') + 1
    print(f"{os.path.basename(filename)} -> chars:{chars} lines:{lines}")


if __name__ == '__main__':
    print(f"Splitting {input_file} (limit: {char_limit} chars)...")

    parts = split_md_file(input_file, output_dir, base_name, limit=char_limit, strip_md=False)
    print("\nParts:")
    for part in parts:
        print_stats(part)
