#!/bin/sh -eu
# Git fetch git repos in directories recursively

usage()
{
    echo "Usage: $0 <directory>"
}

if [ -z "${1}" ]; then
    usage
    exit 1
fi
INPUT_DIR=${1}

# See https://stackoverflow.com/questions/11981716/how-to-quickly-find-all-git-repos-under-a-directory
GIT_REPOS_DIR=$(find "${INPUT_DIR}" -type d -execdir test -d {}/.git \; -prune -print)

for dir in ${GIT_REPOS_DIR}; do
    cd "${dir}"
    echo "Updating git repo in ${dir}"
    timeout 1m git fetch --all
    cd -
done
