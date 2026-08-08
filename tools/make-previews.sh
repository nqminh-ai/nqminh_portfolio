#!/bin/bash
# Regenerate the JPEG previews the portfolio shows for each PDF credential.
#
# The page never embeds PDFs directly: an embedded PDF needs a native viewer, so it renders
# blank on iOS/Android and on desktops without one — and a dozen live PDF viewers on one page
# is what made the certificates section crawl. Previews are flat JPEGs instead.
#
# Run this after dropping a new PDF into certificate/ or job_simulation/. macOS only
# (uses qlmanage + sips, both built in). No renaming needed — the page derives the preview
# path from the PDF path automatically.

set -euo pipefail
cd "$(dirname "$0")/.."

WIDTH=700     # cards render ~245-350px wide; 700 stays crisp on retina
QUALITY=60

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

mkdir -p cert_preview job_preview

render() {
  local src_dir=$1 out_dir=$2
  shopt -s nullglob
  for pdf in "$src_dir"/*.pdf; do
    local base out
    base=$(basename "$pdf" .pdf)
    out="$out_dir/$base.jpg"
    if [ -f "$out" ] && [ "$out" -nt "$pdf" ]; then
      echo "  skip (up to date)  $base"
      continue
    fi
    qlmanage -t -s 1000 -o "$tmp" "$pdf" >/dev/null 2>&1
    sips -s format jpeg -s formatOptions "$QUALITY" --resampleWidth "$WIDTH" \
      "$tmp/$base.pdf.png" --out "$out" >/dev/null
    echo "  built              $base"
  done
}

echo "certificate/ -> cert_preview/"
render certificate cert_preview
echo "job_simulation/ -> job_preview/"
render job_simulation job_preview
echo "Done."
