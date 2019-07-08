---
title: Linux 随记
date: 2017-03-12 00:28:51
tags:
- Linux
categories:
- Technique
- Linux
---

一些没有专门学习的命令，使用 Linux 过程中遇到的，只会简单使用，记录下来以供后续学习。还记录了一些其他问题。

<!--more-->

---
## commands

* dirname

* cut

* sed

* netstat -nltp

-p 显示套接字所属PID和程序名称

* ssh -fCPN 3307:192.168.1.123:3306 -p 6485 will@192.168.1.10

 参数解释
 -C    使用压缩功能,是可选的,加快速度.
 -P    用一个非特权端口进行出去的连接.
 -f    一旦SSH完成认证并建立port forwarding,则转入后台运行.
 -N    不执行远程命令.该参数在只打开转发端口时很有用（V2版本SSH支持）

* tar -zcvpf pv表示保存文件的原属性

* scp 使用公钥验证时，选项 -i 指定私钥文件,指定端口号使用大写的 -P

* lsof [name] 查看已激活进程打开的文件。[name]表示文件名称，不仅仅指普通文件，例如 Unix Socket 也包含其中。[-p <port>] 可指定端口号。

  - -c <进程名>：列出执行<以 -c 指定的字符为开始的命令>的进程所打开的文件；

  - -p <进程号>：列出指定进程号所打开的文件；

  - -i <条件>：列出符合条件的进程。（4、6、协议、:端口、 \@ip ）

lsof -i 4tcp@localhost:3306,ssh - 列出匹配 ipv4、tcp协议、本地、端口号3306或服务ssh的文件

* pidof program [program...]
  program 表示程序名称，该命令返回给定名称程序的进程的PID，打印在标准输出上

## problems

fedora 25 建议使用 /etc/profile.d/<NAME>.sh 定义环境变量，但 echo $PATH 会发现该脚本似乎被执行了两次，这导致 $PATH 有两段重复的 [DIR/bin]:

```
[will@ygl-pc ~]$ echo $PATH
/usr/lib64/qt-3.3/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/usr/local/git/bin:/usr/local/node/bin:/usr/local/jvm/bin:/usr/local/maven/bin:/usr/local/mysql/bin:/home/will/.local/bin:/home/will/bin:/usr/local/git/bin:/usr/local/node/bin:/usr/local/jvm/bin:/usr/local/maven/bin:/usr/local/mysql/bin

```
