---
title: 最小化安装 CentOS 6.8
date: 2017-02-19 17:16:47
tags:
categories:
---

最小化安装 CentOS release 6.8 比较简单，更多的是各种配置和软件安装。

<!--more-->

---

## 下载 CentOS ISO

最新版本下载页面：https://www.centos.org/download/
如果需要下载其他版本：https://wiki.centos.org/Download

根据需要下载相应的 iso 文件，一般需要考虑的是：

* 版本(version)：选择喜欢或需要的版本

* 架构(architecture)：i386(32位)还是x86_64(64位)

* 镜像(image)类型:最小化安装 minimal、网络安装 netinstall 等，其他的可通过 README.txt 了解


我的测试机器是上个年代的 HP Compaq nc6400，不支持64位系统，不能安装 CentOS 7(虽然有非官方的 i386 版本),而且又是最小化安装，
所以我选择的 iso 是 *CentOS-6.8-i386-minimal.iso* 。

除了下载 iso 文件，还需要下载用于验证该 iso 文件的验证文件，例如 sha256sum.txt.asc 。

## 验证 CentOS ISO

ISO 文件在下载过程中，可能会发生错误，尽管下载工具没有提示任何错误，所以一定要验证下载的 ISO 文件。

具体的验证方法可以参考:https://wiki.centos.org/TipsAndTricks/sha256sum

在 Windows 环境下，可以下载 [sha256.exe](http://www.labtestproject.com/files/win/sha256sum/sha256sum.exe) 程序，并将该程序和以上下载的
iso 文件放在同一目录下。然后打开 Windows 命令行工具并切换到它们所在的目录，输入命令：

```
D:\Downloads>sha256sum.exe CentOS-6.5-x86_64-minimal.iso
```

使用文件夹编辑器打开文件 sha256sum.txt.asc，将以上命令输出的哈希值与此文件中相应 iso 的哈希值进行比对，如果不一致就重新下载 CentOS ISO 文件。


## 创建 USB 启动盘

使用 U 盘制作启动盘是很方便和简单的，注意别忘了对 U 盘的内容进行备份。

[Rufus](https://rufus.akeo.ie/) 是一个可以帮助格式化和创建可引导USB闪存盘的工具，在 “创建一个启动盘” 后面的下拉列表中选择 ISO 镜像并点击后面的光盘形状的按钮，在打开的对话框里选择 *CentOS-6.8-i386-minimal.iso* ，最后点击开始等待完成即可。

![](/images/rufus.PNG)

当然除了 Rufus 以外的工具，根据喜好选择即可。

## 安装 CentOS

可以说最小化安装的所有步骤是正常安装的一个子集，其他没什么不同。

我的安装过程简记如下：

* 把 U 盘插入笔记本USB槽

* 开机启动，按 F9 进入启动菜单，选择 USB Hard

* 进入 CentOS 安装欢迎界面，选择第一项 Install or upgrade an existing system

* Choose a Language - English

* Keyboard Type - us

* Installation Method - Hard drive

* Select Partition - /dev/sda1

* Next

* What type of devices will your installation involve? - Basic Storage Devices

* Hostname - 安装完成再配置

* Selected city - Asia/Shanghai

* Root Password - \*\*\*  
Confirm - \*\*\*

* **What type of installation would you like? - Use All Space**

* Install boot loader on /dev/sda - <First sector of boot partition - /dev/sdb1>

* 等待安装完成

* 启动后直接进入 grub,安装出现问题。

* 分析：可能是 minimal 安装介质对服务器进行了优化，在笔记本上安装可能需要进行额外的操作


## 配置

### 创建用户

```
[root@wy ~]adduser ygl

[root@wy ~]passwd ygl
```


### SSH

禁止 root 使用 ssh 登入

\#PermitRootLogin yes
修改为
PermitRootLogin no

### iptables


### Network

修改 /etc/sysconfig/network-scripts/ifcfg-eth0 为:

```
ONBOOT=yes
NM_CONTROLLED=no
BOOTPROTO=static
IPADDR=192.168.1.10
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS1=8.8.8.8
DNS2=8.8.4.4
IPV6INIT=no
```

* 修改 Hostname:

修改文件 /etc/sysconfig/network : HOSTNAME=wy
修改文件 /etc/hosts : 127.0.0.1 后面增加 wy，并添加一行

```
192.168.1.10 wy.ygl.org wy
```


## 安装软件


* 执行系统更新：yum update && yum upgrade

* yum install man vim

* ~~yum install links~~

* yum install lrzsz 能够在 XShell 中使用 rz sz 命令进行文件传输

* rpm -Uvh jdk

* yum install gcc gcc-c++

* 编译安装 apache 并使 service chkconfig 能操作
