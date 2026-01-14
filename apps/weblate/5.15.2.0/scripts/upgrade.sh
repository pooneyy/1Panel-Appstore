#!/bin/bash

if [ -f .env ]; then
  source .env

  mkdir -p "$WEBLATE_ROOT_PATH"
  mkdir -p "$WEBLATE_ROOT_PATH/data"
  mkdir -p "$WEBLATE_ROOT_PATH/cache"

  chown -R 1000:1000 "$WEBLATE_ROOT_PATH"
  chown -R 1000:1000 "$WEBLATE_ROOT_PATH/data"
  chown -R 1000:1000 "$WEBLATE_ROOT_PATH/cache"

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
