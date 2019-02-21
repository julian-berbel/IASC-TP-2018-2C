#!/bin/sh

. ./bin/lib.sh

if [ $# -ne 3 ]; then
  echo "Usage:"
  echo ""
  echo "      ./bin/consumer.sh HOST QUEUE_NAME WAIT: "
  echo ""
  echo "         HOST:      The IP of the host."
  echo "         QUEUE_NAME: The name of the queue which you wish to subscribe to."
  echo "         WAIT: The time in ms the consumer takes to consume the message."
  echo ""
  exit 1
fi

IP=$(get_main_ip)
NAME=$(random_name)

elixir --name "$NAME@$IP" --cookie aReallyDeliciousCookie --no-halt -S mix consumer "main@$1" $2 $3
