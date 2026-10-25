#!/usr/bin/env bash
# Installs SAP Fiori development tools as global npm packages.
# Each option accepts 'latest', 'none' (skip), or a pinned version.
set -e

echo "Activating feature 'fiori-dev-stack'"

# shellcheck source=npm-utils.sh
source "$(dirname "$0")/npm-utils.sh"
require_npm "fiori-dev-stack"

# Feature options are exposed as uppercased environment variables (yo -> YO, generator-fiori -> GENERATOR_FIORI, ...).
install_pkg "yo"                   "${YO:-latest}"
install_pkg "@sap/generator-fiori" "${GENERATOR_FIORI:-latest}"

echo "Done."
