#!/bin/bash

if [ -f .env ]; then
  source .env

  CONFIG_DIR="$CLOUDSAVER_ROOT_PATH/config"
  mkdir -p "$CONFIG_DIR"

  CONFIG_FILE="$CONFIG_DIR/env"
  cp ./config/env.example $CONFIG_FILE
  sed -i "s/JWT_SECRET=.*/JWT_SECRET=$JWT_SECRET/" $CONFIG_FILE

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
