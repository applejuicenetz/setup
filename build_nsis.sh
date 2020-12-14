#!/usr/bin/env bash

set -ex

for NSI in *.nsi; do
  makensis "${NSI}"
done


