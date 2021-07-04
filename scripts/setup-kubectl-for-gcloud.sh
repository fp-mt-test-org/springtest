#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

echo "Installing gcloud..."

google_sdk_path='./google-cloud-sdk'
filename='google-cloud-sdk-346.0.0-darwin-x86_64.tar.gz'

if [[ -d "${google_sdk_path}" ]]; then
    echo "${google_sdk_path} exists!"
else
    download_url="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${filename}"
    echo "Downloading ${download_url}"
    curl "${download_url}" --output "${filename}"
    echo "Download complete, extracting..."
    tar -xzf "${filename}"
    echo "Extract complete."
    echo
fi

brew install kubectl

# Write the key to disc.
key_file_path='key.json'
echo "${gcloud_service_account}" > "${key_file_path}"

# Use the key to get credentials.
gcloud auth \
    activate-service-account \
    --key-file="${key_file_path}" \
    --project="${gcloud_project}"

gcloud container \
    clusters get-credentials cluster-1 \
    --zone us-west1-a \
    --project="${gcloud_project}"
