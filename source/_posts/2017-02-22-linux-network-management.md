---
title: Linux 网络学习笔记
date: 2017-02-22 00:59:28
tags:
categories:
---

关于计算机网络知识的学习，不仅仅是 Linux 下的网络管理。

<!--more-->

## ISO/OSI 模型

网络是做什么的？传输数据。怎么传输？例如 ISO/OSI 模型。

* OSI : Open System Interconnetion

ISO/OSI | 作用
--- | ---
应用层 | 用户接口
表示层 | 数据的表现形式、特定功能如加密
会话层 | 确定网络数据是否要经过远程会话
传输层 | 确定传输协议(TCP或UDP)及端口号、传输前的错误检测、流控
网络层 | IP 地址(包括源和目标的 IP 地址)、选路
数据链路层 | 组帧、MAC 地址、错误检测与修正
物理层 | 设备之间的比特流的传输、物理接口、电气特性等

说明
* 表示层：数据的编码、加密、压缩等
* 流控：例如根据网络的快慢决定什么时候传输。
* 选路：数据是通过各个路由器传递的，选路就是确定数据经由哪些路由器节点。
* 物理接口：例如网线的一端接口是什么样的。
* 电气特性：例如8根线网线只有1、3、2、6用于网络物理层传输。


## TCP/IP 模型

TCP : Transmission Control Protocol
IP : Internet Protocol

TCP/IP 参考了 ISO/OSI ，其对应关系如下:

TCP/IT | ISO/OSI
--- | ---
应用层 | 应用层、表示层、会话层
传输层 | 传输层
网际互连层 | 网络层
网络接口层 | 数据链路层、物理层


### 网络接入层

负责监视数据在主机和网络之间的交换。事实上，TCP/IP本身并未定义该层的协议，而是由参与互联的各网络使用自己的物理层和数据链路层协议，然后与 TCP/IP 的网络接入层进行连接。**地址解析协议(ARP)** 工作在此层，即 ISO/OSI 的数据链路层。

* ARP : Address Resolution Protocol

ARP 把 IP 翻译成长度为 48 位，用 12 个十六进制表示的网卡物理地址，同网段或者说局域网传输数据用的不是 IP 地址，而是网卡的物理地址。IP 地址用于跨网段或者说公网、互联网传输数据。

交换机只识别网卡物理地址，不能识别 IP 地址。

在 windows CMD 下执行 **arp -a**，列出跟当前计算机所有有联系的 IP的 MAC 地址:

```
C:\Users\will>arp -a

接口: 192.168.1.2 --- 0xd #本机
  Internet 地址         物理地址              类型
  192.168.1.1           a0-91-c8-a3-4b-18     动态 #路由器
  192.168.1.4           c8-f6-50-09-12-d7     动态 #iPad
  192.168.1.255         ff-ff-ff-ff-ff-ff     静态
  224.0.0.2             01-00-5e-00-00-02     静态
  224.0.0.22            01-00-5e-00-00-16     静态
  224.0.0.251           01-00-5e-00-00-fb     静态
  224.0.0.252           01-00-5e-00-00-fc     静态
  239.255.255.250       01-00-5e-7f-ff-fa     静态
  255.255.255.255       ff-ff-ff-ff-ff-ff     静态
```

通过 **ping** 只要可以 ping 通就可以查看局域网某台机器的 MAC 地址。

```
C:\Users\will>ping 192.168.1.6

正在 Ping 192.168.1.6 具有 32 字节的数据:
来自 192.168.1.6 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.1.6 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.1.6 的回复: 字节=32 时间<1ms TTL=64
来自 192.168.1.6 的回复: 字节=32 时间<1ms TTL=64

192.168.1.6 的 Ping 统计信息:
    数据包: 已发送 = 4，已接收 = 4，丢失 = 0 (0% 丢失)，
往返行程的估计时间(以毫秒为单位):
    最短 = 0ms，最长 = 0ms，平均 = 0ms

C:\Users\will>arp -a

接口: 192.168.1.2 --- 0xd
  Internet 地址         物理地址              类型
  192.168.1.1           a0-91-c8-a3-4b-18     动态
  192.168.1.4           c8-f6-50-09-12-d7     动态
  192.168.1.6           00-16-d4-e9-4d-56     动态
  192.168.1.255         ff-ff-ff-ff-ff-ff     静态
  224.0.0.2             01-00-5e-00-00-02     静态
  224.0.0.22            01-00-5e-00-00-16     静态
  224.0.0.251           01-00-5e-00-00-fb     静态
  224.0.0.252           01-00-5e-00-00-fc     静态
  239.255.255.250       01-00-5e-7f-ff-fa     静态
  255.255.255.255       ff-ff-ff-ff-ff-ff     静态
```

### 网际互联层

主要解决主机到主机的通信问题。它所包含的协议解决数据包在整个网络上的逻辑传输。该层有三个主要协议：IP、IGMP、ICMP。

* IGMP : Internet Group Management Protocol
* ICMP : Internet Control Messages Protocol

 **ping** 使用的就是 ICMP 。

### 传输层

为应用层实体提供端到端的的通信功能，保证数据包的顺序传送及数据的完整性。两个主要协议：TCP、UDP。

* UDP : User Datagram Protocol

三次握手源自有名的 **两军问题**
参考：http://blog.csdn.net/stone8761/article/details/51680790

**虽然模型名称是 TCP/IP ，但传输层可以有 UDP ??? 是这样么？？？**

### 应用层

为用户提供所需要的各种服务，例如：FTP、Telnet、DNS、SMTP 等。

* FTP : File Transfer Protocol
* Telnet : 远程登录
* DNS : Domain Name Server
* SMTP : Simple Message Transfer Protocol


FTP 接收端口号：21

### 数据封装过程

![](/images/network/datagram.jpg)


## IP

## DNS

## 网关

交换机属于数据链路层设备

## Linux 网络配置


```
[will@syst ~]$ ifconfig
eth0      Link encap:Ethernet  HWaddr 00:16:D4:E9:4D:56  
          inet addr:192.168.1.6  Bcast:192.168.1.255  Mask:255.255.255.0
          inet6 addr: fe80::216:d4ff:fee9:4d56/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1076 errors:0 dropped:0 overruns:0 frame:0
          TX packets:231 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:124591 (121.6 KiB)  TX bytes:21331 (20.8 KiB)
          Interrupt:16

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0
          RX bytes:0 (0.0 b)  TX bytes:0 (0.0 b)
```

对于 eth0:

* Link encap - 网络类型：Ethernet
* HWaddr - 网卡的物理地址 MAC : 00:16:D4:E9:4D:56
* inet addr - 当前 ip 地址
* Bcast - 广播地址
* Mask - 子网掩码
* inet6 addr - ip v6 地址
* MTU - 最大传输单元
* RX packets - 当前接收到的数据包
* TX packets - 当前发送的数据包
* RX bytes
* TX bytes
* Interrupt -

网卡 lo 是本地环回网卡，用于测试当前系统网络协议是否正常，可以 ping 通。

### ifconfig

>This program is obsolete!  For replacement check **ip addr** and **ip link**.  For statistics use **ip -s link**.

配置的 IP 是临时生效的


### 网卡配置文件

/etc/sysconfig/network-scripts/ifcfg-eth0

DEVICE=eth0  网卡设备名,要与配置文件名称一致
BOOTPROTO=

```
[will@syst ~]$ sudo vi /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
HWADDR=00:16:D4:E9:4D:56
TYPE=Ethernet
UUID=20343218-b4de-459b-b1ff-a7ee3b78f11a
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
IPADDR=192.168.1.6
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=202.106.46.151
DNS2=202.106.195.68
USERCTL=no
IPV6INIT=no
```

### 主机名文件

/etc/sysconfig/network

```
[will@syst ~]$ hostname
syst

[will@syst ~]$ sudo vi /etc/sysconfig/network
NETWORKING=yes
HOSTNAME=syst
```

### DNS 配置文件

/etc/resolv.conf

对于 ubuntu ,有些差异，它建议设置在 /etc/resolvconf.d/ 下


## 修改 UUID

对于虚拟机复制来的 Linux ，网卡配置文件中的 UUID 是相同的，需要修改：

* 删除网卡配置文件中的 HWADDR 这一行，也就是 MAC 地址
* sudo rm -rf /etc/udev/rules.d/70-persistent-net.rules，删除网卡和 MAC 地址绑定文件
* 重启系统
