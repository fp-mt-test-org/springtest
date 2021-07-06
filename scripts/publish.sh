#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

default_branch=$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')
current_branch=$(git branch --show-current)

if [[ "${default_branch}" == "${current_branch}" ]]; then
    maturity_level="dev"
else
    maturity_level="snapshot"
fi

echo "Installing svu..."
brew install caarlos0/tap/svu
echo "Install complete."
echo

next_version="$(svu n)"
echo "Next Version: ${next_version}"
echo

service_name='springtest'
artifact_repository_name="${service_name}-docker-${maturity_level}-local"
artifact_tag="${service_name}:${next_version}"
artifact_remote_tag="${artifactory_hostname}/${artifact_repository_name}/${artifact_tag}"

docker tag "${artifact_tag}" "${artifact_remote_tag}"

echo "Tagged ${artifact_tag} as ${artifact_remote_tag}"
echo
echo "Pushing ${artifact_remote_tag} to ${artifact_repository_name}"
echo
jfrog rt \
    docker-push "${artifact_remote_tag}" \
    "${artifact_repository_name}" \
    --build-name="${service_name}" \
    --build-number=4.0.0 \
    --url="https://${artifactory_hostname}/artifactory" \
    --user="${artifactory_username}" \
    --access-token="${artifactory_password}"

echo
echo "jfrog docker-push completed successfully."
