#!/bin/sh
set -euo pipefail

echo "Starting build process..."

for item in *; do
  if [ -d "$item" ]; then
    echo "Building $item..."
    CGO_ENABLED=0 GOOS=linux go build -o "/go-job-output/$item" "./$item/."
  fi
done

echo "Build completed."
