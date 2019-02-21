#!/bin/sh

if [ $# -ne 3 ]; then
  echo "Usage:"
  echo ""
  echo "      ./bin/requests/create_queue.sh HOST QUEUE_NAME QUEUE_TYPE:"
  echo ""
  echo "         HOST:       The IP of the host."
  echo "         QUEUE_NAME: The name you wish the created queue to have."
  echo "         QUEUE_TYPE: The type of the aforementioned queue."
  echo "                     This can be one of: publish_subscribe | work_queue"
  echo ""
  exit 1
fi

curl -X POST -d "name=$2&type=$3" "$1:8880/queue"
