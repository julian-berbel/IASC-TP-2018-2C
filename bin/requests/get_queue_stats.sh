#!/bin/sh

if [ $# -ne 2 ]; then
  echo "Usage:"
  echo ""
  echo "      ./bin/requests/get_queue_stats.sh HOST QUEUE_NAME:"
  echo ""
  echo "         QUEUE_NAME: The name of the queue you wish to get stats on."
  echo "         HOST:       The IP of the host."
  echo ""
  exit 1
fi

curl "$1:8880/queue/$2"
