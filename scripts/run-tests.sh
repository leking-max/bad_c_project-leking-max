#!/usr/bin/env bash
# Прогоняет юнит-тесты через ctest
set -euo pipefail

cd "$(dirname "$0")/.."

ctest --test-dir build --output-on-failure
