#!/bin/sh

if [ $# -ne 3 ]; then
  echo "Usage:"
  echo ""
  echo "      ./bin/consumer.sh NODE_NAME QUEUE_NAME WAIT: "
  echo ""
  echo "         NODE_NAME: For some reason for two nodes to link with each other, the two of them need to have a name."
  echo "                    It's not really used for anything so just put whatever here as long as it's not repeated with another node."
  echo "         QUEUE_NAME: The name of the queue which you wish to subscribe to."
  echo "         WAIT: The time in ms the consumer takes to consume the message."
  echo ""
  exit 1
fi
elixir --name "$1@127.0.0.1" -S mix consumer "n1@127.0.0.1" $2 $3
