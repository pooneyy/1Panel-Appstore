#!/bin/bash

if [ -f .env ]; then
  source .env

  mkdir -p "$SUPER_PRODUCTIVITY_ROOT_PATH"
  mkdir -p "$SUPER_PRODUCTIVITY_ROOT_PATH/data"
  mkdir -p "$SUPER_PRODUCTIVITY_ROOT_PATH/config"

  cp ./conf/webdav.yaml "$SUPER_PRODUCTIVITY_ROOT_PATH/config/webdav.yaml"

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
