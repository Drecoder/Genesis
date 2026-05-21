#!/usr/bin/env bash
set -e

# Load corporate standards
source ./code-quality.env

echo "===================================================="
echo "🛡️ Starting Genesis Corporate Quality Gate Pipeline"
echo "===================================================="

mkdir -p "${OUTPUT_ARTIFACT_DIR}"
go clean -testcache

echo "🏃‍♂️ Executing workspace test matrix..."
# Run tests and capture profile output stream
go test -v -coverprofile="${OUTPUT_ARTIFACT_DIR}/coverage.out" -covermode=atomic ./... || true

echo "===================================================="
echo "📊 IMMEDIATE COVERAGE REPORT SUMMARY"
echo "===================================================="
# This line dynamically outputs the function-by-function coverage to your screen
go tool cover -func="${OUTPUT_ARTIFACT_DIR}/coverage.out"
echo "===================================================="

# Generate human-readable visual HTML asset
go tool cover -html="${OUTPUT_ARTIFACT_DIR}/coverage.out" -o "${OUTPUT_ARTIFACT_DIR}/coverage.html"

TOTAL_COVERAGE=$(go tool cover -func="${OUTPUT_ARTIFACT_DIR}/coverage.out" | grep "total:" | awk '{print $3}' | sed 's/%//')
if [ -z "$TOTAL_COVERAGE" ]; then TOTAL_COVERAGE=0; fi

COVERAGE_INT=$(echo "${TOTAL_COVERAGE}" | cut -d. -f1)

if [ "${COVERAGE_INT}" -lt "${MIN_GLOBAL_COVERAGE_PCT}" ]; then
    echo "❌ QUALITY GATE FAILURE: Current coverage (${TOTAL_COVERAGE}%) is below MVP standard (${MIN_GLOBAL_COVERAGE_PCT}%)."
    exit 1
else
    echo "✅ QUALITY GATE PASSED: Workspace meets corporate compliance criteria."
    exit 0
fi