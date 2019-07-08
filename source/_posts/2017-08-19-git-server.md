---
title: 配置 Git 服务器
date: 2017-08-19 00:28:02
tags:
- Git
- Git Server
categories:
- Technique
- Git
---

```terminal
$ git clone git@192.168.1.6:/opt/git/test.git test3
```

上面的命令先进行 SSH 登录，使用密码或公钥验证，然后再使用 git 用户默认 shell 执行克隆操作。
所以用户 git 的默认 shell 必须能够执行命令，若设置为 /bin/false 则因为无法执行 git clone 操作而失败

<!-- more -->

会出现如下警告

```terminal
$ git clone git@192.168.1.6:/opt/git/test.git test2
Cloning into 'test2'...
Enter passphrase for key '/c/Users/Steven/.ssh/id_rsa':
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

不能让 git 用户具有登录系统的权限，同时还要能执行命令，而 git-shell 同时具备这两点。

权限控制: gitosis gitolite，参考 <<Pro Git>> 第一版
