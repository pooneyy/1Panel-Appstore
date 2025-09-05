#!/bin/bash

if [ -f .env ]; then
  source .env

  mkdir -p "$DIFY_ROOT_PATH"

  cp -r conf/. "$DIFY_ROOT_PATH/"

  env_source="envs/dify.env"
  if [ -f "$env_source" ]; then
    while IFS='=' read -r key value; do
      if [[ -z "$key" || "$key" =~ ^# ]]; then
        continue
      fi
      if ! grep -q "^$key=" .env; then
        echo "$key=$value" >> .env
      fi
    done < "$env_source"
  fi

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
