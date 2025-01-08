#!/bin/bash
set -e

# always set this for scripts but don't declare as ENV..
export DEBIAN_FRONTEND=noninteractive

# install extra Julia packages
julia -e 'using Pkg; Pkg.add(readlines("/rocker_scripts/julia_pkgs.txt"))'