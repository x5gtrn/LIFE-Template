#!/usr/bin/env bash
set -euo pipefail

# Replace <YOUR_NAME> with your GitHub username (or org) that hosts the public TIL repository.
TIL_REMOTE_NAME="til"
TIL_REMOTE_URL="https://github.com/<YOUR_NAME>/til.git"
TIL_BRANCH="main"
PREFIX="vendor/til"

command -v git >/dev/null 2>&1

if git remote | grep -q "^${TIL_REMOTE_NAME}$"; then
  git remote set-url "${TIL_REMOTE_NAME}" "${TIL_REMOTE_URL}"
else
  git remote add "${TIL_REMOTE_NAME}" "${TIL_REMOTE_URL}"
fi

git fetch "${TIL_REMOTE_NAME}" "${TIL_BRANCH}" --prune

if [ -d "${PREFIX}" ]; then
  git subtree pull --prefix="${PREFIX}" "${TIL_REMOTE_NAME}" "${TIL_BRANCH}" --squash
else
  git subtree add --prefix="${PREFIX}" "${TIL_REMOTE_NAME}" "${TIL_BRANCH}" --squash
fi

echo "✅ synced: ${TIL_REMOTE_NAME}/${TIL_BRANCH} -> ${PREFIX}"
