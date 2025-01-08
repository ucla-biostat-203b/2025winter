#!/bin/bash
set -e

## build ARGs
NCPUS=${NCPUS:--1}

JULIA_VERSION=${1:-${JULIA_VERSION:-latest}}

# a function to install apt packages only if they are not installed
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

ARCH_LONG=$(uname -p)
ARCH_SHORT=$ARCH_LONG

if [ "$ARCH_LONG" = "x86_64" ]; then
    ARCH_SHORT="x64"
fi

apt_install curl ca-certificates

install2.r --error --skipmissing --skipinstalled -n "$NCPUS" \
    JuliaCall \
    JuliaConnectoR

# Download the juliaup installer and add to PATH
curl -fsSL https://install.julialang.org | sudo -u rstudio sh -s -- -y
. /home/rstudio/.profile

# Get the latest Julia version
if [ $JULIA_VERSION = "latest" ]; then
    # shellcheck disable=SC2016
    juliaup add release
    else
    juliaup add $JULIA_VERSION
fi

ln -s /home/rstudio/.juliaup/bin/julia /usr/local/bin/julia

julia --version

# Clean up
rm -rf /var/lib/apt/lists/*
rm -rf /tmp/downloaded_packages

## Strip binary installed lybraries from RSPM
## https://github.com/rocker-org/rocker-versioned2/issues/340
strip /usr/local/lib/R/site-library/*/libs/*.so

# # Make the venv owned by the staff group, so users can install packages
# # without having to be root
# fix-permissions "${JULIAUP_DEPOT_PATH}/juliaup"
