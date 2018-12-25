#!/bin/bash
iex --name "$1@127.0.0.1" --erl "-config sys.config" -S mix