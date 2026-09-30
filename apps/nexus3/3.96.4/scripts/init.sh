#!/bin/bash

if [ -f .env ]; then
  source .env

  mkdir -p "$NEXUS3_ROOT_PATH"
  mkdir -p "$NEXUS3_ROOT_PATH/data"

  chown -R 200:0 "$NEXUS3_ROOT_PATH"
  chown -R 200:0 "$NEXUS3_ROOT_PATH/data"

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
