#!/bin/bash

if [ -f .env ]; then
  source .env

  sed -i '/^.*=""/d' .env

  mkdir -p "$OUTLINE_ROOT_PATH"
  mkdir -p "$OUTLINE_ROOT_PATH/data"

  chown -R 1001:1001 "$OUTLINE_ROOT_PATH"
  chmod -R 1777 "$OUTLINE_ROOT_PATH"

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
