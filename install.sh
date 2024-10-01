#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

OS=$(uname -s)
ARCH=$(uname -m)

# Set the architecture variable
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == "arm64" ]] || [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
fi

API_URL="https://api.github.com/repos/dymensionxyz/roller/releases/latest"

# Determine the download URL
if [ -z "$ROLLER_RELEASE_TAG" ]; then
    TGZ_URL=$(curl -s "$API_URL" \
        | grep "browser_download_url.*_${OS}_${ARCH}.tar.gz" \
        | cut -d : -f 2,3 \
        | tr -d \" \
        | tr -d ' ')
    
    # Check if the URL was found
    if [ -z "$TGZ_URL" ]; then
        echo "Error: Download URL not found. Please check the release assets."
        exit 1
    fi
else
    TGZ_URL="https://github.com/dymensionxyz/roller/releases/download/$ROLLER_RELEASE_TAG/roller_${OS}_${ARCH}.tar.gz"
fi

ROLLER_BIN_PATH="/usr/local/bin/roller"

# Check and remove existing files if they exist
if [ -f "$ROLLER_BIN_PATH" ] || [ -f "$ROLLAPP_EVM_PATH" ] || [ -f "$DYMD_BIN_PATH" ] || [ -d "$INTERNAL_DIR" ];
