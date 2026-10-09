BUILD_DIR ?= build

all: build

build:
	cmake -S . -B $(BUILD_DIR)
	cmake --build $(BUILD_DIR)

test: build
	ctest --test-dir $(BUILD_DIR) --output-on-failure

format:
	./scripts/format.sh

check-format:
	./scripts/check-format.sh

setup:
	./scripts/setup.sh

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all build test format check-format setup clean
