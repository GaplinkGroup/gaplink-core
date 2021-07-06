#!/bin/bash

SERVER_V2RAY_PORT=$1
SERVER_V2RAY_UUID=$2

[ -z "$SERVER_V2RAY_PORT" ] && exit 1
[ -z "$SERVER_V2RAY_UUID" ] && exit 1

docker pull v2fly/v2fly-core

mkdir -p /etc/v2ray

docker run --rm --workdir /etc/v2ray -v /etc/v2ray:/etc/v2ray v2fly/v2fly-core:latest v2ctl cert --ca --domain=EXTERNAL_IP --expire=87600h --file=server -name=common -org=common

cat > /etc/v2ray/config.json <<EOF
{
  "inbounds": [
    {
      "port": $SERVER_V2RAY_PORT,
      "protocol": "vmess",
      "settings": {
        "clients": [
          {
            "id": "$SERVER_V2RAY_UUID",
            "alterId": 100
          }
        ]
      },
      "streamSettings": {
        "network": "h2",
        "httpSettings": {
          "path": "/admin"
        },
        "security": "tls",
        "tlsSettings": {
          "certificates": [
            {
              "certificateFile": "/etc/v2ray/server_cert.pem",
              "keyFile": "/etc/v2ray/server_key.pem"
            }
          ]
        }
      }
    }
  ],
  "outboundDetour": [
    {
      "tag": "blocked",
      "protocol": "blackhole",
      "settings": {}
    }
  ],
  "outbound": {
    "protocol": "freedom",
    "settings": {}
  },
  "log": {
    "access": "/var/log/v2ray/access.log",
    "loglevel": "info",
    "error": "/var/log/v2ray/error.log"
  },
  "routing": {
    "settings": {
      "rules": [
        {
          "ip": [
            "0.0.0.0/8",
            "10.0.0.0/8",
            "100.64.0.0/10",
            "127.0.0.0/8",
            "169.254.0.0/16",
            "172.16.0.0/12",
            "192.0.0.0/24",
            "192.0.2.0/24",
            "192.168.0.0/16",
            "198.18.0.0/15",
            "198.51.100.0/24",
            "203.0.113.0/24",
            "::1/128",
            "fc00::/7",
            "fe80::/10"
          ],
          "type": "field",
          "outboundTag": "blocked"
        }
      ]
    },
    "strategy": "rules"
  }
}
EOF
docker create --restart always -v /etc/v2ray:/etc/v2ray -p $SERVER_V2RAY_PORT:$SERVER_V2RAY_PORT --name v2ray v2fly/v2fly-core:latest

echo "Server CA: "
cat /etc/v2ray/server_cert.pem | base64 --wrap=0
echo