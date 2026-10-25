#!/bin/bash
# Scenario test for 'typescript' (typescript + tsx).
set -e

source dev-container-features-test-lib

check "tsc is installed" tsc --version
check "tsx is installed" tsx --version

reportResults
