#!/bin/bash

if [ -f .env ]; then
  source .env

  mkdir -p "$TOPIAM_CE_ROOT_PATH"
  mkdir -p "$TOPIAM_CE_ROOT_PATH/logs"
  chmod -R 777 "$TOPIAM_CE_ROOT_PATH"

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
