#!/usr/bin/env bash
# Full setup: install all tools + deploy configs.
# Runs bootstrap.sh then install.sh.
#
# Usage:
#   ./setup.sh           # interactive (prompts for optional tools)
#   ./setup.sh --all     # non-interactive (installs everything)

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$DIR/bootstrap.sh" "$@"
echo ""
"$DIR/install.sh"

echo ""
printf "\033[32m%s\033[0m\n" "=== Full setup complete ==="
echo "Run 'exec zsh' to reload your shell."
