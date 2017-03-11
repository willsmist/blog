---
title: linux-awesome
date: 2017-03-12 04:28:51
tags:
categories:
---

一些没有专门学习的命令，使用 Linux 过程中遇到的，只会简单使用，记录下来以供后续学习。还记录了一些其他问题。

<!--more-->

---
## commands

* lsof [name] 查看已激活进程打开的文件。[name]表示文件名称，不仅仅指普通文件，例如 Unix Socket 也包含其中。[-p <port>] 可指定端口号。

* pidof program [program...]
  program 表示程序名称，该命令返回给定名称程序的进程的PID，打印在标准输出上

## problems

fedora 25 建议使用 /etc/profile.d/<NAME>.sh 定义环境变量，但 echo $PATH 会发现该脚本似乎被执行了两次，这导致 $PATH 有两段重复的 [DIR/bin]:

```
[will@ygl-pc ~]$ echo $PATH
/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/usr/local/git/bin:/usr/local/node/bin:/usr/local/jvm/bin:/usr/local/maven/bin:/usr/local/mysql/bin:/home/will/.local/bin:/home/will/bin:/usr/local/git/bin:/usr/local/node/bin:/usr/local/jvm/bin:/usr/local/maven/bin:/usr/local/mysql/bin

```
