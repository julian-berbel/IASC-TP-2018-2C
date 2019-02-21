#!/bin/sh

. ./bin/lib.sh

if [ $# -ne 4 ]; then
  echo "Usage:"
  echo ""
  echo "      ./bin/producer.sh HOST QUEUE_NAME MESSAGE WAIT: "
  echo ""
  echo "         HOST:      The IP of the host."
  echo "         QUEUE_NAME: The name of the queue which you wish to subscribe to."
  echo "         MESSAGE: The message you wish to send to the queue."
  echo "         WAIT: The time in ms you wish to wait between posts."
  echo ""
  exit 1
fi

IP=$(get_main_ip)
NAME=$(random_name)

elixir --name "$NAME@$IP" --cookie aReallyDeliciousCookie -S mix producer "main@$1" $2 "$3" $4
