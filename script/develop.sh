#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "--- Building and Running  via Docker Compose ---"
docker-compose -f docker-compose.yml up --build --abort-on-container-exit
