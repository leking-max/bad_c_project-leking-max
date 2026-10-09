#!/usr/bin/env bash
# Конфигурирует и собирает проект в ./build
set -euo pipefail

cd "$(dirname "$0")/.."

cmake -S . -B build
cmake --build build
