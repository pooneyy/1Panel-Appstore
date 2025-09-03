#!/bin/bash

if [ -f .env ]; then
  source .env

  mkdir -p "$KOMGA_ROOT_PATH"
  mkdir -p "$KOMGA_ROOT_PATH/config"
  mkdir -p "$KOMGA_ROOT_PATH/data"

  chown -R 1000:1000 "$KOMGA_ROOT_PATH"
  chown -R 1000:1000 "$KOMGA_ROOT_PATH/config"
  chown -R 1000:1000 "$KOMGA_ROOT_PATH/data"


  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
