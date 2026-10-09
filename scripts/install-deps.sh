#!/usr/bin/env bash
# Ставит всё, что нужно для сборки, тестов и форматирования (Ubuntu/Debian).
set -euo pipefail

sudo apt-get update
sudo apt-get install -y \
    build-essential \
    cmake \
    clang-format \
    libcmocka-dev \
    git

echo "готово"
