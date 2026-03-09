#!/usr/bin/env bash
# Run Oracle and NOP tests by using a lowercase path so Docker image names are valid.
# Root cause: Docker requires image names to be lowercase; the folder "Harbour_Assignment-main"
# makes Harbor use "hb__Harbour_Assignment-main", which Docker rejects.
# Harbor resolves symlinks, so we copy the project to a lowercase-named dir and run from there.

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOWERCASE_DIR="/tmp/harbour_word_count_task"
export PATH="${HOME}/.local/bin:${PATH}"

if ! command -v harbor &>/dev/null; then
  echo "harbor not found. Install with: uv tool install harbor"
  echo "Ensure \$HOME/.local/bin is in your PATH."
  exit 1
fi

# Copy project to a path with a lowercase basename (Harbor uses resolved path for Docker)
rm -rf "$LOWERCASE_DIR"
cp -a "$SCRIPT_DIR" "$LOWERCASE_DIR"
trap "rm -rf $LOWERCASE_DIR" EXIT

# Run from the copy so Docker sees environment name "harbour_word_count_task"
cd "$LOWERCASE_DIR"
rm -rf jobs/test-oracle jobs/test-nop

echo "========================================="
echo "Running Oracle (expect Mean: 1.000)"
echo "========================================="
harbor run --agent oracle --path . --job-name test-oracle

echo ""
echo "========================================="
echo "Running NOP (expect Mean: 0.000)"
echo "========================================="
harbor run --agent nop --path . --job-name test-nop

# Copy results back into the project
mkdir -p "$SCRIPT_DIR/jobs"
cp -r jobs/test-oracle "$SCRIPT_DIR/jobs/" 2>/dev/null || true
cp -r jobs/test-nop "$SCRIPT_DIR/jobs/" 2>/dev/null || true

echo ""
echo "========================================="
echo "Done. Results are in jobs/"
echo "========================================="
