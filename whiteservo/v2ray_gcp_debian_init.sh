
#!/bin/bash

SERVER_V2RAY_PORT=$1
SERVER_V2RAY_UUID=$2

[ -z "$SERVER_V2RAY_PORT" ] && exit 1
[ -z "$SERVER_V2RAY_UUID" ] && exit 1

curl -L -s https://install.direct/go.sh | bash -s --

mkdir -p /etc/v2ray
cat > /etc/v2ray/config.json <<EOF
{
  "inbound": {
    "streamSettings": {
      "network": "tcp",
      "kcpSettings": {
        "uplinkCapacity": 20,
        "downlinkCapacity": 100,
        "readBufferSize": 2,
        "mtu": 1350,
        "header": {
          "type": "none",
          "request": null,
          "response": null
        },
        "tti": 50,
        "congestion": false,
        "writeBufferSize": 2
      }
    },
    "protocol": "vmess",
    "port": $SERVER_V2RAY_PORT,
    "settings": {
      "clients": [
        {
          "alterId": 100,
          "security": "auto",
          "id": "$SERVER_V2RAY_UUID",
          "level": 1
        }
      ]
    }
  },
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

systemctl daemon-reload
systemctl enable v2ray
systemctl restart v2ray
