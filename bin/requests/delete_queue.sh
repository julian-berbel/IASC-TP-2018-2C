#!/bin/sh

if [ $# -ne 2 ]; then
  echo "Usage:"
  echo ""
  echo "      ./bin/requests/delete_queue.sh HOST QUEUE_NAME:"
  echo ""
  echo "         HOST:       The IP of the host."
  echo "         QUEUE_NAME: The name of the queue you wish to delete."
  echo ""
  exit 1
fi

curl -X DELETE "$1:8880/queue/$2"
