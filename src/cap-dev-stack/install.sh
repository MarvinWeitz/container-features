#!/usr/bin/env bash
# Installs SAP CAP development tools as global npm packages.
# Each option accepts 'latest', 'none' (skip), or a pinned version.
set -e

echo "Activating feature 'cap-dev-stack'"

# shellcheck source=npm-utils.sh
source "$(dirname "$0")/npm-utils.sh"
require_npm "cap-dev-stack"

# Feature options are exposed as uppercased environment variables (cds-dk -> CDS_DK, ...).
install_pkg "@sap/cds-dk"                   "${CDS_DK:-latest}"
install_pkg "mbt"                           "${MBT:-latest}"
install_pkg "mta"                           "${MTA:-latest}"

echo "Done."
