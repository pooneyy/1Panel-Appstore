#!/bin/bash

if [ -f .env ]; then
  source .env

  mkdir -p "$KOMGA_ROOT_PATH"
  chown -R 1000:1000 "$KOMGA_ROOT_PATH"

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
