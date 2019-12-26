#!/bin/sh

set -e

git --git-dir=/var/html/gitdir --work-tree=/var/html/worktree reset --hard
git --git-dir=/var/html/gitdir --work-tree=/var/html/worktree pull --ff-only

echo "Git worktree updated successfully"
