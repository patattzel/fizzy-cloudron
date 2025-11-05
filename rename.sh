#!/usr/bin/env bash
# rename_paths.sh
# Renames directories and files containing "collection" → "board"
# Excludes db/migrate and prevents nested board/board paths.

set -euo pipefail

ROOT_DIR="/home/jorge/Work/basecamp/fizzy"
EXCLUDE_DIR="$ROOT_DIR/db/migrate"

# 1. Rename directories first (deepest first)
find "$ROOT_DIR" -type d -name '*collection*' \
  ! -path "$EXCLUDE_DIR/*" | sort -r | while IFS= read -r dir; do
    new_dir="${dir//collection/board}"
    if [[ "$new_dir" != *"board/board"* ]]; then
      echo "Renaming directory: $dir → $new_dir"
      mv "$dir" "$new_dir"
    fi
done

# 2. Rename files (after directories exist)
find "$ROOT_DIR" -type f -name '*collection*' \
  ! -path "$EXCLUDE_DIR/*" | while IFS= read -r file; do
    new_name="${file//collection/board}"
    if [[ "$new_name" != *"board/board"* ]]; then
      echo "Renaming file: $file → $new_name"
      mv "$file" "$new_name"
    fi
done

echo "✅ File and directory renaming complete."
