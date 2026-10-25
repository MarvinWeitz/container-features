#!/bin/bash
# Scenario test for 'typescript' (typescript only, tsx skipped).
set -e

source dev-container-features-test-lib

check "tsc is installed" tsc --version
check "tsx is not installed" bash -c "! command -v tsx"

reportResults
