#!/bin/sh
BIN="/usr/bin/snell-server"
CONF="/etc/snell/snell-server.conf"
# reuse existing config when the container restarts
run() {
  #sysctl -w net.core.rmem_max=26214400
  #sysctl -w net.core.rmem_default=26214400
  #sysctl -w net.ipv4.tcp_fastopen=3
  # echo 'net.ipv4.tcp_fastopen = 3' > /etc/sysctl.conf
  #sysctl -p
  #TFO_STATUS=$(cat /proc/sys/net/ipv4/tcp_fastopen)
  #echo "tfo status is ${TFO_STATUS}"
  if [ -f ${CONF} ]; then
    echo "Found existing config..."
  else
    if [ -z ${PSK} ]; then
      PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 31)
      echo "Using generated PSK: ${PSK}"
    else
      echo "Using predefined PSK: ${PSK}"
    fi
    echo "Generating new config..."
    mkdir /etc/snell/
    echo "[snell-server]" >> ${CONF}
    echo "listen = 0.0.0.0:8388" >> ${CONF}
    echo "psk = ${PSK}" >> ${CONF}
    echo "obfs = http" >> ${CONF}
  fi
  ${BIN} -c ${CONF}
}
if [ -z "$@" ]; then
  run
else
  exec "$@"
fi
