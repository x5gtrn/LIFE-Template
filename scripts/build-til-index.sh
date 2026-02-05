#!/usr/bin/env bash
set -euo pipefail

ROOT="vendor/til"
OUT="docs/til-index.md"

mkdir -p "$(dirname "${OUT}")"

{
  echo "# TIL Index"
  echo ""
  echo "_Generated from \`${ROOT}\`_"
  echo ""
} > "${OUT}"

for d in $(find "${ROOT}" -mindepth 1 -maxdepth 1 -type d | sort); do
  topic="$(basename "${d}")"
  echo "## ${topic}" >> "${OUT}"
  echo "" >> "${OUT}"

  files=$(find "${d}" -maxdepth 1 -type f -name "*.md" | sort || true)
  if [ -z "${files}" ]; then
    echo "- (no entries yet)" >> "${OUT}"
    echo "" >> "${OUT}"
    continue
  fi

  while IFS= read -r f; do
    title="$(basename "${f}" .md)"
    echo "- [${title}](${f})" >> "${OUT}"
  done <<< "${files}"

  echo "" >> "${OUT}"
done

echo "✅ generated: ${OUT}"
