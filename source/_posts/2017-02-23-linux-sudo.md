---
title: Linux sudo
date: 2017-02-23 02:54:21
tags:
categories:
---
sudo allows a system administrator to delegate authority to give certain users—or groups of users—the ability to run commands as root or another user while providing an audit trail of the commands and their arguments.

<!--more-->

---

Sudo is an alternative to su for running commands as root. Unlike su, which launches a root shell that allows all further commands root access, sudo instead grants temporary privilege escalation to a single command. By enabling root privileges only when needed, sudo usage reduces the likelihood that a typo or a bug in an invoked command will ruin the system.
Sudo can also be used to run commands as other users; additionally, sudo logs all commands and failed access attempts for security auditing.

命令 visuao 会打开文件 /etc/sudoers

可通过命令 ```man 5 sudoers``` 查看配置文件 /etc/sudoers 的帮助文档

赋予 sudo 权限的语法格式为：

Syntax:
      user    MACHINE=COMMANDS

命令使用绝对路径，普通用户使用该命令时也要用绝对路径(centos6 做了优化，可直接写命令，但其他linux不一定可行 )

慎重书写语句，否则很容易造成安全问题，例如

user  ALL=/bin/vi

会使普通用户 user 通过 /bin/vi /etc/shadow 以 root 身份访问和修改用户的密码信息。
