#!/bin/sh

set -e
set -u

HUGO_VERSION="0.85.0"
HUGO_ARCH="64bit"
HUGO_PATH="/usr/local/bin"

# Download binaries from release
wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-${HUGO_ARCH}.tar.gz
wget https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_checksums.txt

# Verify checksums
grep hugo_extended_${HUGO_VERSION}_Linux-${HUGO_ARCH}.tar.gz hugo_${HUGO_VERSION}_checksums.txt | sha256sum -c

# Prepare folders
mkdir -p ${HUGO_PATH}

# Unpack downloaded content
tar -zxf hugo_extended_${HUGO_VERSION}_Linux-${HUGO_ARCH}.tar.gz -C ${HUGO_PATH}

# Verify executable
ls -l ${HUGO_PATH}/hugo
${HUGO_PATH}/hugo version

# Create autocompletion script
mkdir -p /etc/bash_completion.d
${HUGO_PATH}/hugo gen autocomplete > /etc/bash_completion.d/hugo.sh

# Create version file
echo -n "${HUGO_VERSION}" > /etc/hugo-release
