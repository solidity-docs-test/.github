#!/bin/bash
set -uo pipefail

USERNAME=$1
EMAIL=$2

ORIGINAL_URL="https://github.com/ethereum/solidity.git"
git remote add english "$ORIGINAL_URL"

git config user.name "$USERNAME"
git config user.email "$EMAIL"

## Fetch from translated origin
git fetch english --quiet
sync_branch="sync-$(git describe --tags --always english/develop)"

# pass the hash and the branch name to action "create PR"
echo "::set-output name=branch_name::$sync_branch"

# pull from ethereum/solidity develop
git pull english develop --rebase=false --squash

# unstage everything
git rm -r --cached .

# stage only selected files / directories
git add docs/*

# remove untracked files
git clean -d --force --exclude=.gitignore --exclude=README.md
