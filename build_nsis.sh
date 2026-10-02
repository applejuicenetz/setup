#!/usr/bin/env bash

set -euxo pipefail

cd "$(dirname "$0")"
mkdir -p build

for ARCH in amd64 aarch64; do
  makensis -WX "-DSETUP_ARCH=${ARCH}" nsis_applejuice_setup.nsi
done

