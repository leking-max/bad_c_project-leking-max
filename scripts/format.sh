#!/usr/bin/env bash
# Форматирует весь C-код по .clang-format (стиль WebKit).
set -euo pipefail

cd "$(dirname "$0")/.."

find src tests -name '*.c' -o -name '*.h' | sort | xargs clang-format -i --style=file

echo "отформатировано"
