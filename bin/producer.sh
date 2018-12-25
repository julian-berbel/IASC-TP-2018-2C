#!/bin/bash

if [ $# -ne 4 ]; then
  echo "Usage:"
  echo ""
  echo "      ./bin/producer.sh NODE_NAME QUEUE_NAME MESSAGE WAIT: "
  echo ""
  echo "         NODE_NAME: For some reason for two nodes to link with each other, the two of them need to have a name."
  echo "                    It's not really used for anything so just put whatever here as long as it's not repeated with another node."
  echo "         QUEUE_NAME: The name of the queue which you wish to subscribe to."
  echo "         MESSAGE: The message you wish to send to the queue."
  echo "         WAIT: The time in ms you wish to wait between posts."
  echo ""
  exit 1
fi

elixir --name "$1@127.0.0.1" -S mix producer "n1@127.0.0.1" $2 "$3" $4
