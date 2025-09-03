#!/bin/bash

if [ -f .env ]; then
  source .env

  mkdir -p "$WECHATPADPRO_ROOT_PATH"

  touch "$WECHATPADPRO_ROOT_PATH/.env"


  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
