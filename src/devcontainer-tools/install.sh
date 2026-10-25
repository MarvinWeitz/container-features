#!/usr/bin/env bash
# Installs the Dev Container CLI (@devcontainers/cli) as a global npm package.
# Accepts 'latest', 'none' (skip), or a pinned version.
set -e

echo "Activating feature 'devcontainer-tools'"

# shellcheck source=npm-utils.sh
source "$(dirname "$0")/npm-utils.sh"
require_npm "devcontainer-tools"

# Feature option 'cli' is exposed as CLI environment variable.
install_pkg "@devcontainers/cli" "${CLI:-latest}"

echo "Done."
