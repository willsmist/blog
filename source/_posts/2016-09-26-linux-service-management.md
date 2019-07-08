---
title: Linux 服务管理
date: 2016-09-26 09:04:39
tags:
- Linux
categories:
- Technique
- Linux
---

系统为了某些功能必须要提供一些服务(不论是系统本身还是网络方面)，这个服务就称为 Service。本文中的系统环境为 CentOS 6.8。

<!--more-->

---

# 运行级别

运行级别 | 含义
--- | ---
0 | 关机
1 | 单用户模式，主要用于系统修复
2 | 不完全的命令行模式，不含 NFS 服务
3 | 完全的命令行模式，标准字符界面
4 | 系统保留
5 | 图形模式
6 | 重启动

## 查看运行级别

```bash
$ runlevel
```

执行结果：N 3

N - 表示上一个运行级别,输出 N 表示没有上个运行级别，意味着启动后进入 3 后没有执行过 `init <level>` 命令

3 - 标准字符界面，表示当前运行级别

## 更改运行级别

```bash
$ init <level>
```

即使 `init <level>` 没有成功执行而进入指定的级别，之后执行命令 `runlevel` 输出的却是成功执行了 `init <level>` 之后的结果，例如

```bash
$ runlevel
3
$ init 5
Retrigger failed udev events    [ OK ]
Starting jexec services    # 一直阻塞在此处
# ctrl+c 之后，执行 runlevel
$ runlevel
3 5
```

也就是说，命令 `runlevel` 输出的的第一个级别是上一次执行 `init <level>` 之前的当前运行级别，第二个级别是执行 `init <level>` 时指定的级别。

不建议使用 init 0 和 init 6 执行关机和重启命令,可能造成某些服务不能正确关闭，不在 root 下执行会不成功。修改 /etc/inittab ,可以使系统启动后直接进入指定的运行级别，`/etc/inittab` 部分内容如下所示

```text
# Default runlevel. The runlevels used are:
#   0 - halt (Do NOT set initdefault to this)
#   1 - Single user mode
#   2 - Multiuser, without NFS (The same as 3, if you do not have networking)
#   3 - Full multiuser mode
#   4 - unused
#   5 - X11
#   6 - reboot (Do NOT set initdefault to this)
#
id:3:initdefault:
```

# 端口

一个 IP 地址可以有65536个端口(0-65535)，一般的，0-10000是系统预留端口，10001以上的端口用户可自由使用。

## 查看端口

### /etc/services

文件 `/etc/services` 以 `service-name port/protocol [aliases] [# comment]` 的形式描述了每个服务，`/etc/services` 部分内容如下

```text
# service-name  port/protocol  [aliases ...]   [# comment]

ftp-data        20/tcp
ftp-data        20/udp
# 21 is registered to ftp, but also used by fsp
ftp             21/tcp
ftp             21/udp          fsp fspd
ssh             22/tcp                          # The Secure Shell (SSH) Protocol
ssh             22/udp                          # The Secure Shell (SSH) Protocol
telnet          23/tcp
telnet          23/udp
# 24 - private mail system
lmtp            24/tcp                          # LMTP Mail Delivery
lmtp            24/udp                          # LMTP Mail Delivery
smtp            25/tcp          mail
smtp            25/udp          mail
```

### netstat

`Netstat` 命令用于显示各种网络相关信息，如网络连接、路由表、接口状态 (Interface Statistics)、masquerade 连接、多播成员 (Multicast Memberships)。

`-a` 显示所有(all)选项，默认(没有-a)不显示 LISTEN 相关
`-t` 仅显示tcp相关选项
`-u` 仅显示udp相关选项
`-n` 拒绝显示别名，能显示数字的全部转化成数字。
`-l` 仅列出有在 Listen (监听) 的服務状态
`-p` 显示建立相关链接的程序名
`-r` 显示路由信息，路由表
`-e` 显示扩展信息，例如uid等
`-s` 按各个协议进行统计
`-c` 每隔一个固定时间，执行该netstat命令。

说明：`LISTEN` 和 `LISTENING` 的状态只有用 `-a` 或者 `-l` 才能看到。

```bash
$ netstat -tulp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name
tcp        0      0 localhost:smtp              *:*                         LISTEN      1476/master
tcp        0      0 *:ssh                       *:*                         LISTEN      1397/sshd
tcp        0      0 localhost:smtp              *:*                         LISTEN      1476/master
tcp        0      0 *:ssh                       *:*                         LISTEN      1397/sshd
$ netstat -tunlp
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name
tcp        0      0 127.0.0.1:25                0.0.0.0:*                   LISTEN      1476/master
tcp        0      0 0.0.0.0:22                  0.0.0.0:*                   LISTEN      1397/sshd
tcp        0      0 ::1:25                      :::*                        LISTEN      1476/master
tcp        0      0 :::22                       :::*                        LISTEN      1397/sshd
```

`Recv-Q` 接收队列
`Send-Q` 发送队列
`Foreign Address` 远程连接本服务的地址

```bash
$ netstat -anp
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address               Foreign Address             State       PID/Program name
tcp        0      0 127.0.0.1:25                0.0.0.0:*                   LISTEN      1476/master
tcp        0      0 0.0.0.0:22                  0.0.0.0:*                   LISTEN      1397/sshd
tcp        0     64 192.168.1.10:22             192.168.1.2:62142           ESTABLISHED 1886/sshd
tcp        0      0 192.168.1.10:22             192.168.1.2:62386           ESTABLISHED 2449/sshd
tcp        0      0 ::1:25                      :::*                        LISTEN      1476/master
tcp        0      0 :::22                       :::*                        LISTEN      1397/sshd
Active UNIX domain sockets (servers and established)
Proto RefCnt Flags       Type       State         I-Node PID/Program name    Path
unix  2      [ ACC ]     STREAM     LISTENING     9032   1/init              @/com/ubuntu/upstart
unix  9      [ ]         DGRAM                    12907  1330/rsyslogd       /dev/log
unix  2      [ ACC ]     STREAM     LISTENING     13283  1476/master         public/cleanup
unix  2      [ ACC ]     STREAM     LISTENING     13290  1476/master         private/tlsmgr
unix  2      [ ACC ]     STREAM     LISTENING     13294  1476/master         private/rewrite
unix  2      [ ]         DGRAM                    9534   586/udevd           @/org/kernel/udev/udevd

```

可以发现有如下所示的两行

```bash
tcp        0     64 192.168.1.10:22             192.168.1.2:62142           ESTABLISHED 1886/sshd
tcp        0      0 192.168.1.10:22             192.168.1.2:62386           ESTABLISHED 2449/sshd
```

这对应远程连接的两个 XShell 会话, `ESTABLISHED` 表示正在连接着 `22` 端口号，也就是 `ssh` 服务。

# RPM 安装的服务

## 命令 chkconfig

`chkconfig --list` 查看已安装的服务以及各个服务在不同运行级别下的自启动状态

~~RPM 包常规安装位置~~

~~* /etc/init.d/ : 启动脚本~~
~~* /etc/sysconfig/ : 初始化环境配置文件~~
~~* /etc/ : 配置文件~~
~~* /etc/xinetd.conf : xinetd配置文件~~
~~* /etc/xinetd.d/ : 基于 xinetd 服务的启动脚本~~
~~* /var/lib/ : 服务产生的数据~~
~~* /var/log/ : 日志~~

## 命令 service

`service --status-all` runs all init scripts, in alphabetical order, with the status command.

## 服务启动和停止

通过 RPM 安装的服务的管理脚本位于 `/etc/rc.d/init.d/` 目录，`/etc/init.d/` 是 `/etc/rc.d/init.d/` 的符号链接

* `/etc/init.d/<service-name> start | stop | restart | status`

* `service <service-name> start | stop | restart | status`

### 服务自启动

* `chkconfig [--level <level>] [service-name] [on|off]`

* 修改 `/etc/rc.d/rc.local` 文件

* 使用 `ntsysv` 管理自启动，可看作 chkconfig 的图形化操作

# 从源代码安装的服务

## 启动与停止

`<script-absolute-path> start|stop|status|restart`

* 使 `service` 命令可操作

在 `/etc/rc.d/init.d/` 下创建服务管理脚本的软连接，例如

```bash
$ ln -s /usr/local/apache2/bin/apachectl /etc/rc.d/init.d/
$ service apachectl restart
```

## 自启动

通过修改 `/etc/rc.d/rc.local` 文件添加启动命令实现

例如使从源码安装的 apache 服务随系统启动而启动，需要在该文件中添加下面的一行

```text
/usr/local/apache2/bin/apachectl start
```

* 使 chkconfig 命令可操作

在服务管理脚本文件添加如下两行(`#` 和 `:` 后面各有一个空格)

```text
# chkconfig: <runlevel> <StartOrder> <KillOrder>
# description: <some description>
```

使 `chkconfig` 可管理 apache 服务的自启动，配置如下

```text
# chkconfig: 35 96 20
# description: apache installed from source.
```

`<StartOrder>` 和 `<KillOrder>` 可根据 `/etc/rc.d/rcN.d` 下的各软链接的名称确定，避免冲突。