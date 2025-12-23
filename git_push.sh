#!/usr/bin/env bash
set -euo pipefail

# Ensure we're inside a git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: This folder is not a Git repository."
  exit 1
fi

echo "Current git status:"
git status
echo

read -r -p "Enter commit message: " msg

if [[ -z "${msg}" ]]; then
  echo "Error: Commit message cannot be empty."
  exit 1
fi

git add .

if git diff --cached --quiet; then
  echo "Nothing to commit (no staged changes)."
  exit 0
fi

git commit -m "${msg}"

current_branch="$(git branch --show-current)"

if git rev-parse --abbrev-ref --symbolic-full-name "@{u}" >/dev/null 2>&1; 
then
  git push
else
  echo "No upstream set for '${current_branch}'. Pushing and setting 
upstream..."
  git push -u origin "${current_branch}"
fi

echo "Done: changes added, committed, and pushed."
