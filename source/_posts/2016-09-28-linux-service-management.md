---
title: Linux 服务管理
date: 2016-09-26 09:04:39
tags:
- Linux
- CentOS
- Service
categories:
- Technique
- Linux
- CentOS
---
系统为了某些功能必须要提供一些服务(不论是系统本身还是网络方面)，这个服务就称为 Service。本文基于 CentOS 6.8 。

<!--more-->

---

## Linux 系统的运行级别

运行级别 | 含义
--- | ---
0 | 关机
1 | 单用户模式，主要用于系统修复
2 | 不完全的命令行模式，不含 NFS 服务
3 | 完全的命令行模式，就是标准
4 | 系统保留
5 | 图形模式
6 | 重启动

```
$ runlevel
```
查看运行级别

执行结果：N 5

N - Null,表示上一个运行级别
5 - 图形模式，表示当前运行级别

```
$ init <level>
```

更改运行级别

不建议使用 init 0 和 init 6 执行关机和重启命令,不在 root 下执行会不成功。

修改 /etc/inittab ,可以使系统启动后直接进入指定的运行级别。

例如
