#!/bin/bash

if [ -f .env ]; then
  source .env

  if [ ! -d $SEAWEEDFS_ROOT_PATH/prometheus ]; then
    mkdir -p $SEAWEEDFS_ROOT_PATH/prometheus
  fi
  cp -rn ./config/* $SEAWEEDFS_ROOT_PATH/prometheus/

  echo "Check Finish."

else
  echo "Error: .env file not found."
fi
