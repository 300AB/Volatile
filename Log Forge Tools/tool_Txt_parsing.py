import os
from bs4 import BeautifulSoup
from collections import defaultdict

# Base path relative to the script itself
script_dir = os.path.dirname(os.path.abspath(__file__))
input_file = os.path.join(script_dir, 'chat_export.html')
txt_dir = os.path.join(script_dir, 'output_txt')
os.makedirs(txt_dir, exist_ok=True)

output_full = os.path.join(txt_dir, 'chat_export_full.txt')
output_user = os.path.join(txt_dir, 'chat_export_user.txt')
output_unknown = os.path.join(txt_dir, 'chat_export_unknown.txt')

PRESERVE_LABELS = True


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


role_counts = defaultdict(int)


def clean_text(text):
    if not PRESERVE_LABELS:
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
    else:
        lines = text.splitlines()
        cleaned_lines = []
        blank_streak = 0
        for line in lines:
            if line.startswith("### User") or line.startswith("### Unknown") or line.startswith("### Assistant"):
                cleaned_lines.append(line)
                blank_streak = 0
            else:
                stripped = line.rstrip()
                if stripped == '':
                    blank_streak += 1
                    if blank_streak <= 1:
                        cleaned_lines.append('')
                else:
                    blank_streak = 0
                    cleaned_lines.append(stripped)
        while cleaned_lines and cleaned_lines[0].strip() == '' and not cleaned_lines[0].startswith("###"):
            cleaned_lines.pop(0)
        while cleaned_lines and cleaned_lines[-1].strip() == '' and not cleaned_lines[-1].startswith("###"):
            cleaned_lines.pop()
        return '\n'.join(cleaned_lines)


# Write full context (all messages)
with open(output_full, 'w', encoding='utf-8') as f_full:
    for role, text in messages:
        role_counts[role] += 1
        label = f"### {role} #{role_counts[role]}:"
        cleaned = clean_text(f"{label}\n\n{text}")
        f_full.write(f"{cleaned}\n\n---\n\n")

# Write only User (no code)
with open(output_user, 'w', encoding='utf-8') as f_user:
    user_count = 0
    for role, text in messages:
        if role == "User":
            user_count += 1
            label = f"### User #{user_count}:"
            cleaned = clean_text(f"{label}\n\n{text}")
            parts = cleaned.split('```')
            dialog_only = ''.join(parts[i] for i in range(len(parts)) if i % 2 == 0).strip()
            if dialog_only:
                f_user.write(f"{dialog_only}\n\n---\n\n")

# Write only Unknown (no code)
with open(output_unknown, 'w', encoding='utf-8') as f_unknown:
    unknown_count = 0
    for role, text in messages:
        if role == "Unknown":
            unknown_count += 1
            label = f"### Unknown #{unknown_count}:"
            cleaned = clean_text(f"{label}\n\n{text}")
            parts = cleaned.split('```')
            dialog_only = ''.join(parts[i] for i in range(len(parts)) if i % 2 == 0).strip()
            if dialog_only:
                f_unknown.write(f"{dialog_only}\n\n---\n\n")


# Endcap: print stats
def print_stats(filename):
    with open(filename, 'r', encoding='utf-8') as f:
        content = f.read()
    chars = len(content)
    lines = content.count('\n') + 1
    print(f"{os.path.basename(filename)} -> chars:{chars} lines:{lines}")

print_stats(output_full)
print_stats(output_user)
print_stats(output_unknown)
