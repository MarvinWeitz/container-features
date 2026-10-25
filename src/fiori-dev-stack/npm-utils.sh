#!/usr/bin/env bash
# Shared helpers for the npm-based features.
#
# This is the canonical copy. Features are packaged and published independently, so each one
# ships its own copy as src/<feature>/npm-utils.sh. After editing this file, run
# scripts/sync-lib.sh; CI fails if a copy differs.

# require_npm <feature-id>
#   Exits with an error if npm is not on PATH.
require_npm() {
	if ! command -v npm >/dev/null 2>&1; then
		echo "ERROR: npm was not found on PATH." >&2
		echo "       Add a Node.js feature (e.g. ghcr.io/devcontainers/features/node) before '$1'." >&2
		exit 1
	fi
}

# install_pkg <package-name> <version>
#   version == "none" or "" -> skip
#   version == "latest"     -> npm install -g <package-name>
#   anything else           -> npm install -g <package-name>@<version>
install_pkg() {
	local name="$1" ver="$2"
	if [ "$ver" = "none" ] || [ -z "$ver" ]; then
		echo "Skipping ${name}"
		return 0
	fi
	if [ "$ver" = "latest" ]; then
		echo "Installing ${name} (latest)"
		npm install -g "${name}"
	else
		echo "Installing ${name}@${ver}"
		npm install -g "${name}@${ver}"
	fi
}
