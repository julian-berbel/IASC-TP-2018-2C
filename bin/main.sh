#!/bin/sh

. ./bin/lib.sh

if [ $# -eq 1 ]; then
  echo $1 > cluster_nodes
fi

IP=$(get_main_ip)

echo "Setting elixir node up in main@$IP"

iex --name "main@$IP" --cookie aReallyDeliciousCookie -S mix run
