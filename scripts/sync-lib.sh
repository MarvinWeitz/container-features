#!/usr/bin/env bash
# Copies lib/npm-utils.sh into every feature that uses it.
#
# Usage:
#   ./scripts/sync-lib.sh          # update the copies
#   ./scripts/sync-lib.sh --check  # fail if any copy is out of date (used in CI)
set -e

cd "$(dirname "$0")/.."

FEATURES="cap-dev-stack devcontainer-tools fiori-dev-stack npm-feeds typescript"

status=0
for feature in $FEATURES; do
	target="src/${feature}/npm-utils.sh"
	if [ "$1" = "--check" ]; then
		if ! cmp -s lib/npm-utils.sh "$target"; then
			echo "ERROR: ${target} differs from lib/npm-utils.sh. Run ./scripts/sync-lib.sh." >&2
			status=1
		fi
	else
		cp lib/npm-utils.sh "$target"
		echo "Updated ${target}"
	fi
done
exit "$status"
