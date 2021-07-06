## 环境要求

云服务器一台

## 安装并配置远程服务

1. 登录到云服务root账户

```
cd /root
curl -fsSL https://get.docker.com -o get-docker.sh
bash get-docker.sh
git clone https://github.com/GaplinkGroup/gaplink-core.git
cd gaplink-core/whiteservo/
SPORT=443
SUUID=5e87d895-b13d-425d-ba03-0ba1df8e28db
bash v2ray_gcp_debian_init.sh $SPORT $SUUID

docker start v2ray
```

2. 配置云服务器防火墙允许配置的端口流量流入，如果云服务器出口流量也有限制，则也需要开启，比如53/TCP 需要访问出去
3. 记录云服务器ip，端口跟UUID，Server CA 本地安装需要使用到
4. 开始使用
