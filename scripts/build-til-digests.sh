#!/usr/bin/env bash
set -euo pipefail

BASE_SHA="${1:-}"
if [ -z "${BASE_SHA}" ]; then
  echo "Usage: $0 <BASE_SHA>"
  exit 1
fi

ROOT="vendor/til"
DAILY_OUT="docs/til-daily-digest.md"

mkdir -p docs docs/til-weekly

TODAY_JST="$(TZ=Asia/Tokyo date -d 'yesterday' +%F)"
NOW_JST="$(TZ=Asia/Tokyo date '+%F %H:%M JST')"

ISO_WEEK="$(TZ=Asia/Tokyo date +%G-W%V)"
WEEK_FILE="docs/til-weekly/${ISO_WEEK}.md"

WEEK_START_JST="$(TZ=Asia/Tokyo date -d 'monday 00:00' '+%F %H:%M:%S %Z')"

CHANGES="$(git diff --name-status "${BASE_SHA}" -- "${ROOT}" || true)"

render_changes_block() {
  local changes="$1"
  if [ -z "${changes}" ]; then
    echo "_No changes in \`${ROOT}\`._"
    return
  fi

  echo "### Added"
  echo ""
  awk '$1=="A"{print "- \`" $2 "\`"}' <<< "${changes}" || true
  echo ""
  echo "### Modified"
  echo ""
  awk '$1=="M"{print "- \`" $2 "\`"}' <<< "${changes}" || true
  echo ""
  echo "### Deleted"
  echo ""
  awk '$1=="D"{print "- \`" $2 "\`"}' <<< "${changes}" || true
  echo ""
}

TODAY_SECTION_FILE="$(mktemp)"
{
  echo "## ${TODAY_JST}"
  echo ""
  echo "_Generated: ${NOW_JST}_"
  echo ""
  render_changes_block "${CHANGES}"
  echo "<!-- /DATE:${TODAY_JST} -->"
  echo ""
} > "${TODAY_SECTION_FILE}"

if [ ! -f "${DAILY_OUT}" ]; then
  {
    echo "# TIL Daily Digest"
    echo ""
    echo "This file is auto-generated daily from subtree sync results."
    echo ""
  } > "${DAILY_OUT}"
fi

TMP_DAILY="$(mktemp)"
awk -v d="${TODAY_JST}" '
  BEGIN {skip=0}
  $0 == "<!-- DATE:" d " -->" {skip=1; next}
  $0 == "<!-- /DATE:" d " -->" {skip=0; next}
  skip==0 {print}
' "${DAILY_OUT}" > "${TMP_DAILY}"

TODAY_WRAPPED="$(mktemp)"
{
  echo "<!-- DATE:${TODAY_JST} -->"
  cat "${TODAY_SECTION_FILE}"
} > "${TODAY_WRAPPED}"

TMP_DAILY2="$(mktemp)"
awk -v insfile="${TODAY_WRAPPED}" '
  BEGIN {inserted=0}
  {
    print
    if (!inserted && $0 ~ /^This file is auto-generated daily/) {
      print ""
      while ((getline line < insfile) > 0) print line
      close(insfile)
      inserted=1
    }
  }
  END {
    if (!inserted) {
      print ""
      while ((getline line < insfile) > 0) print line
      close(insfile)
    }
  }
' "${TMP_DAILY}" > "${TMP_DAILY2}"

mv "${TMP_DAILY2}" "${DAILY_OUT}"

rm -f "${TODAY_SECTION_FILE}" "${TMP_DAILY}" "${TODAY_WRAPPED}"

echo "✅ updated: ${DAILY_OUT}"

SINCE_ARG="${WEEK_START_JST}"
LOG_RAW="$(git log --since="${SINCE_ARG}" --name-status --pretty="format:@@@%H %ad" --date=short -- "${ROOT}" || true)"

ADDED="$(mktemp)"
MODIFIED="$(mktemp)"
DELETED="$(mktemp)"

awk '/^@@@/ {next} $1=="A" {print $2}' <<< "${LOG_RAW}" | sort -u > "${ADDED}" || true
awk '/^@@@/ {next} $1=="M" {print $2}' <<< "${LOG_RAW}" | sort -u > "${MODIFIED}" || true
awk '/^@@@/ {next} $1=="D" {print $2}' <<< "${LOG_RAW}" | sort -u > "${DELETED}" || true

{
  echo "# TIL Weekly Digest: ${ISO_WEEK}"
  echo ""
  echo "_Week start (JST): ${WEEK_START_JST}_"
  echo "_Generated: ${NOW_JST}_"
  echo ""

  echo "## Added (unique)"
  echo ""
  if [ -s "${ADDED}" ]; then
    sed 's/^/- \`&\`/' "${ADDED}"
  else
    echo "- (none)"
  fi
  echo ""

  echo "## Modified (unique)"
  echo ""
  if [ -s "${MODIFIED}" ]; then
    sed 's/^/- \`&\`/' "${MODIFIED}"
  else
    echo "- (none)"
  fi
  echo ""

  echo "## Deleted (unique)"
  echo ""
  if [ -s "${DELETED}" ]; then
    sed 's/^/- \`&\`/' "${DELETED}"
  else
    echo "- (none)"
  fi
  echo ""

  echo "## Notes"
  echo ""
  echo "- This file is rebuilt daily for accuracy."
  echo "- Paths refer to the imported subtree under \`${ROOT}\`."
} > "${WEEK_FILE}"

rm -f "${ADDED}" "${MODIFIED}" "${DELETED}"

echo "✅ updated: ${WEEK_FILE}"
