#!/bin/bash

if [ -f .env ]; then
  source .env

  mkdir -p "$SUPER_PRODUCTIVITY_ROOT_PATH"
  mkdir -p "$SUPER_PRODUCTIVITY_ROOT_PATH/data"
  mkdir -p "$SUPER_PRODUCTIVITY_ROOT_PATH/config"

  if [ ! -f "$SUPER_PRODUCTIVITY_ROOT_PATH/app/glance.yml" ]; then
    cp ./conf/webdav.yaml "$SUPER_PRODUCTIVITY_ROOT_PATH/config/webdav.yaml"
  fi

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
