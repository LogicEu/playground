#!/bin/bash
args=$(git submodule status | awk '{ print $2 }')
for arg in $args
do
    pushd $arg/ && git pull origin main && popd
done
