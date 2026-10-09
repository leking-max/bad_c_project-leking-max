#!/usr/bin/env bash
# Полная последовательность: зависимости -> сборка -> форматирование -> тесты.
# Проверки не прерывают друг друга: сначала всё запускаем, потом отдаём код возврата.
set -euo pipefail

cd "$(dirname "$0")/.."

./scripts/install-deps.sh
./scripts/build.sh

status=0

echo "--- проверка форматирования ---"
./scripts/check-format.sh || status=1

echo "--- тесты ---"
./scripts/run-tests.sh || status=1

exit "$status"
