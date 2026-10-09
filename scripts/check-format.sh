#!/usr/bin/env bash
# Проверяет, что весь C-код отформатирован по .clang-format (стиль WebKit).
set -euo pipefail

cd "$(dirname "$0")/.."

status=0
while IFS= read -r file; do
  clang-format --dry-run --Werror --style=file "$file" || status=1
done < <(find src tests -name '*.c' -o -name '*.h' | sort)

if [ "$status" -ne 0 ]; then
  echo "проверка форматирования не пройдена"
fi

exit "$status"
