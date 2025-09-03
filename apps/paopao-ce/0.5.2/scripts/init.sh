#!/bin/bash

if [ -f .env ]; then
  source .env

  mkdir -p "$PAOPAO_CE_ROOT_PATH"
  mkdir -p "$PAOPAO_CE_ROOT_PATH/config"
  mkdir -p "$PAOPAO_CE_ROOT_PATH/scripts"
  cp ./conf/config.yaml "$PAOPAO_CE_ROOT_PATH/config/config.yaml"
  cp ./conf/paopao-mysql.sql "$PAOPAO_CE_ROOT_PATH/scripts/paopao-mysql.sql"

  chown -R 1000:1000 "$PAOPAO_CE_ROOT_PATH"

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
