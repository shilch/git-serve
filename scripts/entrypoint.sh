#!/bin/sh

set -e

if [ -z "${GIT_REPOSITORY}" ]; then
	echo 'GIT_REPOSITORY has not been specified' >&2
	exit 1
fi

WORKTREE='/var/html/worktree'
GITDIR='/var/html/gitdir'

rm -rf ${WORKTREE} ${GITDIR}

# Setup Git environment
git clone													\
	"--separate-git-dir=${GITDIR}"	\
	"${GIT_REPOSITORY}"							\
	"${WORKTREE}"

# Checkout proper branch/commit
[ -z "${GIT_REFERENCE}" ] || git checkout "${GIT_REFERENCE}"

# Set permissions for hook.sh which runs as another user to work
chmod -R 777 "${WORKTREE}" "${GITDIR}"

# Start nginx in current process
exec nginx -g 'daemon off;'
