#!/bin/bash

if [ $# -ne 2 ]; then
  echo "Usage:"
  echo ""
  echo "      ./consumer.sh NODE_NAME QUEUE_NAME: "
  echo ""
  echo "         NODE_NAME: For some reason for two nodes to link with each other, the two of them need to have a name."
  echo "                    It's not really used for anything so just put whatever here as long as it's not repeated with another node."
  echo "         QUEUE_NAME: The name of the queue which you wish to subscribe to."
  echo ""
  exit 1
fi
elixir --sname $1 -S mix consumer "main@$USER" $2
