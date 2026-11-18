#!/bin/bash

if [ -f .env ]; then
  source .env

  DATA_DIR="$N8N_ROOT_PATH/data"

  mkdir -p "$DATA_DIR"

  chmod -R 777 "$DATA_DIR"

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
