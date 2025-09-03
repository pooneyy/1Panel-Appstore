#!/bin/bash

if [ -f .env ]; then
  source .env

  if [ ! -d $BILI_FETCHER_ROOT_PATH/config ]; then
    mkdir -p $BILI_FETCHER_ROOT_PATH/config
  fi
  cp -rn ./config/* $BILI_FETCHER_ROOT_PATH/config/

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
