## 原料

1. 本地linux操作系统的pc设备一台
2. 任何支援[ArchlinuxArm](https://archlinuxarm.org/)的设备以及对应配件
3. 至少两个以太网网口，如果没有则用USB网卡拓展

## 环境要求

上游网络为DHCP自动分配ip的网关
下游无要求

## FAQ
1. 上游网络如果开启了DHCP snooping之类或者绑定mac地址，是否不能使用？
答，是也不是，网络环境必须手动指定ip，或者需要绑定mac地址的，则需要特殊调整才能使用

## 安装

#### 安装ArchlinuxArm

假设这里使用树莓派4B
则参考[这里](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4#installation)安装

最后

1. 把tf插入树莓派，树莓派以普通设备用网线接入到路由器下
2. 用串行接口或者ssh登录树莓派root帐号


#### 安装Gaplink

继续上面的步骤，已经ssh登录树莓派root帐号之后

```
cd /root/
pacman-key --init
pacman-key --populate archlinuxarm
curl -L -o gaplink-builder.tar.gz https://github.com/GaplinkGroup/gaplink-builder/archive/master.tar.gz
tar xf gaplink-builder.tar.gz

cd gaplink-builder-master/archlinuxarm
bash bootstrap.sh
sync
```

## 配置

#### 使用Gaplink

1. 安装完成之后，关闭树莓派，树莓派的两个网口分别接上游口比如路由光猫，下游口接wifi路由器或者电脑，无顺序要求
2. 等待3分钟之后到下游口的任意设备上用浏览器访问 http://gaplink.internal/ 进行配置，配置远程服务器,
填入远程服务器生成的ip地址，端口，UUID，Server CA之后保存并重启服务，然后切换到域名配置，
添加需要通过的网络地址比如 google.com, googlevideo.com, youtube.com
3. 开始使用
