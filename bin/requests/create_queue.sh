#!/bin/sh

if [ $# -ne 2 ]; then
  echo "Usage:"
  echo ""
  echo "      ./bin/requests/get_queue_stats.sh QUEUE_NAME QUEUE_TYPE:"
  echo ""
  echo "         QUEUE_NAME: The name you wish the created queue to have."
  echo "         QUEUE_TYPE: The type of the aforementioned queue."
  echo "                     This can be one of: publish_subscribe | work_queue"
  echo ""
  exit 1
fi

curl -X POST -d "name=$1&type=$2" localhost:8880/queue
