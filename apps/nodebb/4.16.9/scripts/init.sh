#!/bin/bash

if [ -f .env ]; then
  source .env

  mkdir -p "$NODEBB_ROOT_PATH"
  mkdir -p "$NODEBB_ROOT_PATH/node_modules"
  mkdir -p "$NODEBB_ROOT_PATH/build"
  mkdir -p "$NODEBB_ROOT_PATH/uploads"
  mkdir -p "$NODEBB_ROOT_PATH/config"

  if [ -z "$NODEBB_DB_NAME" ]; then
    NODEBB_DB_NAME="nodebb"
  fi

  if [ -z "$NODEBB_DB_USER" ]; then
    NODEBB_DB_USER=""
  fi

  if [ -z "$NODEBB_DB_PASSWORD" ]; then
    NODEBB_DB_PASSWORD=""
  fi

  SETUP_JSON_PATH="$NODEBB_ROOT_PATH/setup.json"
  cp ./conf/setup.json "$SETUP_JSON_PATH"
  sed -i "
    s|\$NODEBB_DB_HOST|$NODEBB_DB_HOST|g;
    s|\$NODEBB_DB_PORT|$NODEBB_DB_PORT|g;
    s|\$NODEBB_DB_NAME|$NODEBB_DB_NAME|g;
    s|\$NODEBB_DB_USER|$NODEBB_DB_USER|g;
    s|\$NODEBB_DB_PASSWORD|$NODEBB_DB_PASSWORD|g;
    s|\$NODEBB_DB|$NODEBB_DB|g
  " "$SETUP_JSON_PATH"


  chown -R 1001:1001 "$NODEBB_ROOT_PATH"
  chown -R 1001:1001 "$NODEBB_ROOT_PATH/node_modules"
  chown -R 1001:1001 "$NODEBB_ROOT_PATH/build"
  chown -R 1001:1001 "$NODEBB_ROOT_PATH/uploads"
  chown -R 1001:1001 "$NODEBB_ROOT_PATH/config"

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
