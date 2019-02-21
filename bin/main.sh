#!/bin/sh

if [ $# -eq 1 ]; then
  echo $1 > cluster_nodes
fi

IP=$(echo "$(ifconfig eth1 || ifconfig eth0 || ifconfig wlp2s0)" | grep -o -E "inet addr:[^ ]*" | cut -d ':' -f 2)

echo "Setting elixir node up in main@$IP"

iex --name "main@$IP" --cookie aReallyStrongCookie -S mix run
