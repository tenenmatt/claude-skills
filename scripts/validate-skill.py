#!/usr/bin/env python3
"""Check a skill folder's SKILL.md frontmatter against the rules the Claude app enforces on upload.

Usage: validate-skill.py <skill-dir>   (exit 1 with a message per problem)

Kept dependency-free, so frontmatter values must be single-line (no YAML block scalars).
"""
import re
import sys
from pathlib import Path

NAME_MAX = 64
DESCRIPTION_MAX = 1024
RESERVED = ("anthropic", "claude")


def frontmatter(text):
    lines = text.splitlines()
    if not lines or lines[0].strip() != "---":
        return None
    for i, line in enumerate(lines[1:], start=1):
        if line.strip() == "---":
            fields = {}
            for raw in lines[1:i]:
                m = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", raw)
                if m:
                    value = m.group(2).strip()
                    if len(value) >= 2 and value[0] == value[-1] and value[0] in "\"'":
                        value = value[1:-1]
                    fields[m.group(1)] = value
            return fields
    return None


def check(skill_dir):
    skill_dir = Path(skill_dir)
    where = f"{skill_dir.name}/SKILL.md"
    problems = []
    fm = frontmatter((skill_dir / "SKILL.md").read_text(encoding="utf-8"))
    if fm is None:
        return [f"{where}: no frontmatter (needs to start with a --- block)"]

    name = fm.get("name", "")
    if not name:
        problems.append(f"{where}: missing 'name'")
    else:
        if name != skill_dir.name:
            problems.append(f"{where}: name '{name}' doesn't match its folder '{skill_dir.name}'")
        if len(name) > NAME_MAX:
            problems.append(f"{where}: name is {len(name)} characters (max {NAME_MAX})")
        if not re.fullmatch(r"[a-z0-9]+(-[a-z0-9]+)*", name):
            problems.append(f"{where}: name must be lowercase letters, digits and single hyphens")
        for word in RESERVED:
            if word in name.lower():
                problems.append(f"{where}: name can't contain the reserved word '{word}'")

    desc = fm.get("description", "")
    if not desc:
        problems.append(f"{where}: missing 'description'")
    elif desc in ("|", ">", "|-", ">-"):
        problems.append(f"{where}: write the description on one line (block scalars aren't supported here)")
    else:
        if len(desc) > DESCRIPTION_MAX:
            problems.append(f"{where}: description is {len(desc)} characters (max {DESCRIPTION_MAX})")
        if re.search(r"<[^>]*>", desc):
            problems.append(f"{where}: description can't contain XML/HTML tags")
    return problems


if __name__ == "__main__":
    if len(sys.argv) != 2:
        sys.exit(__doc__)
    problems = check(sys.argv[1])
    for p in problems:
        print(f"invalid: {p}", file=sys.stderr)
    sys.exit(1 if problems else 0)
