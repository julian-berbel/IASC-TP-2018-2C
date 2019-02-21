get_main_ip() {
  echo "$(ifconfig eth1 || ifconfig eth0 || ifconfig wlp2s0)" | grep -o -E "inet addr:[^ ]*" | cut -d ':' -f 2
}

random_name() {
  cat /dev/urandom | tr -cd 'a-f0-9' | head -c 5
}
