import os
from bs4 import BeautifulSoup
from collections import defaultdict

# === Setup paths ===
script_dir = os.path.dirname(os.path.abspath(__file__))
input_file = os.path.join(script_dir, 'chat_export.html')

# Output folders
md_dir = os.path.join(script_dir, 'output_md')
os.makedirs(md_dir, exist_ok=True)

# Output files
output_full = os.path.join(md_dir, 'chat_export_full.md')
output_user = os.path.join(md_dir, 'chat_export_user.md')
output_unknown = os.path.join(md_dir, 'chat_export_unknown.md')
output_code = os.path.join(md_dir, 'chat_export_code.md')

# === Parsing ===
def extract_code_block(pre_tag):
    return pre_tag.get_text()

def extract_text_with_code(msg_div):
    pre = msg_div.find('pre')
    if pre:
        code_text = extract_code_block(pre)
        pre.extract()
        normal_text = msg_div.get_text(separator='\n').strip()
        return f"{normal_text}\n\n```\n{code_text}\n```"
    else:
        return msg_div.get_text(separator='\n').strip()

with open(input_file, 'r', encoding='utf-8') as f:
    soup = BeautifulSoup(f, 'html.parser')

main = soup.find('main')
print("Main found:", bool(main))

turns = main.find_all('article', class_='text-token-text-primary')
messages = []

for turn in turns:
    header = turn.find('h5', class_='sr-only')
    if header:
        role_text = header.get_text(strip=True)
        if "You said" in role_text:
            role = "User"
        elif "ChatGPT said" in role_text or "Assistant" in role_text:
            role = "Assistant"
        elif "Unknown" in role_text:
            role = "Unknown"
        else:
            role = "Unknown"
    else:
        role = "Unknown"

    msg_div = turn.find('div', class_='text-base')
    if msg_div:
        text = extract_text_with_code(msg_div)
        if text:
            messages.append((role, text))

# === Utilities ===
def clean_text(text):
    lines = [line.rstrip() for line in text.splitlines()]
    while lines and lines[0].strip() == '':
        lines.pop(0)
    while lines and lines[-1].strip() == '':
        lines.pop()
    cleaned_lines = []
    blank_streak = 0
    for line in lines:
        if line.strip() == '':
            blank_streak += 1
            if blank_streak <= 1:
                cleaned_lines.append('')
        else:
            blank_streak = 0
            cleaned_lines.append(line)
    return '\n'.join(cleaned_lines)

# === Track role counts ===
role_counts = defaultdict(int)

# === Write full export ===
with open(output_full, 'w', encoding='utf-8') as f_full:
    for role, text in messages:
        role_counts[role] += 1
        label = f"{role} #{role_counts[role]}"
        cleaned = clean_text(text)
        f_full.write(f"### {label}:\n\n{cleaned}\n\n---\n\n")

# === Write user only (no code blocks) ===
with open(output_user, 'w', encoding='utf-8') as f_user:
    user_count = 0
    for role, text in messages:
        if role == "User":
            user_count += 1
            cleaned = clean_text(text)
            parts = cleaned.split('```')
            dialog_only = ''.join(parts[i] for i in range(len(parts)) if i % 2 == 0).strip()
            if dialog_only:
                f_user.write(f"### User #{user_count}:\n\n{dialog_only}\n\n---\n\n")

# === Write unknown only (no code blocks) ===
with open(output_unknown, 'w', encoding='utf-8') as f_unknown:
    unknown_count = 0
    for role, text in messages:
        if role == "Unknown":
            unknown_count += 1
            cleaned = clean_text(text)
            parts = cleaned.split('```')
            dialog_only = ''.join(parts[i] for i in range(len(parts)) if i % 2 == 0).strip()
            if dialog_only:
                f_unknown.write(f"### Unknown #{unknown_count}:\n\n{dialog_only}\n\n---\n\n")

# === Write only code blocks (from all roles) ===
with open(output_code, 'w', encoding='utf-8') as f_code:
    for role, text in messages:
        parts = text.split('```')
        code_blocks = [parts[i] for i in range(1, len(parts), 2)]
        for code in code_blocks:
            cleaned_code = code.strip()
            if cleaned_code:
                f_code.write(f"### {role} Code:\n\n```\n{cleaned_code}\n```\n\n")

# === Print stats ===
def print_stats(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
    chars = len(content)
    lines = content.count('\n') + 1
    print(f"{os.path.basename(filename)} -> chars:{chars} lines:{lines}")

print_stats(output_full)
print_stats(output_user)
print_stats(output_unknown)
print_stats(output_code)
