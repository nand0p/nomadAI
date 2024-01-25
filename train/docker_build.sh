#!/bin/bash -e

VERSION=$(cat version.txt)

for i in $(find docker -type d); do
  echo "build docker $i:${VERSION}";
  echo
  echo "run docker $i:${VERSION}";
  echo
  echo "test docker $i:${VERSION}";
  echo
done

echo namespace containers appropriately for nomad job definitions

echo after container is built and tests pass

echo nomad job definition is updated with new tag version

echo nomad job definition is executed 

echo assert container runs in cluster
