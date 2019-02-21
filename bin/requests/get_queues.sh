#!/bin/sh

if [ $# -ne 1 ]; then
  echo "Usage:"
  echo ""
  echo "      ./bin/requests/get_queues.sh HOST:"
  echo ""
  echo "         HOST:       The IP of the host."
  echo ""
  exit 1
fi

curl $1:8880/queue
echo ""
