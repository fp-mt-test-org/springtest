#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
current_branch=$(git branch --show-current)

echo "Installing svu..."
brew install caarlos0/tap/svu
echo "Install complete."
echo

if [[ "${default_branch}" == "${current_branch}" ]]; then
    next_version="$(svu n)"
else
    next_version="$(svu n)-SNAPSHOT"
fi

echo "Next Version: ${next_version}"
echo

./mvnw -Drevision="${next_version}" spring-boot:build-image
