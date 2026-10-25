#!/usr/bin/env bash
# Installs TypeScript and tsx as global npm packages.
# Each option accepts 'latest', 'none' (skip), or a pinned version.
set -e

echo "Activating feature 'typescript'"

# shellcheck source=npm-utils.sh
source "$(dirname "$0")/npm-utils.sh"
require_npm "typescript"

# Feature options are exposed as uppercased environment variables.
# typescript -> TYPESCRIPT, tsx -> TSX
install_pkg "typescript" "${TYPESCRIPT:-latest}"
install_pkg "tsx"        "${TSX:-latest}"

echo "Done."
