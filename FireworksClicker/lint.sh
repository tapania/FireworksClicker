#!/bin/bash

# lint.sh - Run all linting tools for FireworksClicker
# Usage: ./lint.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "========================================"
echo "Running swift-format lint..."
echo "========================================"
xcrun swift-format lint -r FireworksClicker

echo ""
echo "========================================"
echo "Running SwiftLint..."
echo "========================================"
swiftlint lint

echo ""
echo "========================================"
echo "All linting checks passed!"
echo "========================================"
