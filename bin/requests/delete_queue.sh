#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage:"
  echo ""
  echo "      ./bin/requests/get_queue_stats.sh QUEUE_NAME:"
  echo ""
  echo "         QUEUE_NAME: The name of the queue you wish to delete."
  echo ""
  exit 1
fi

curl -X DELETE "localhost:8880/queue/$1"
