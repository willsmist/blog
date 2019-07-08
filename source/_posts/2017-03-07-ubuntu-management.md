---
title: Ubuntu 系统管理
date: 2017-03-07 00:15:34
tags:
- Linux
categories:
- Technique
- Linux
---

Ubuntu 服务器使用记录

<!--more-->

---

## 系统时间

### 修改时区

#### Using the Command Line (terminal)

Using the command line, you can use **sudo dpkg-reconfigure** tzdata.

1. sudo dpkg-reconfigure tzdata

2. Follow the directions in the terminal.

3. The timezone info is saved in **/etc/timezone** - which can be edited or used below


#### Using the Command Line (unattended)

1. Find out the long description for the timezone you want to configure.

2. Save this name to /etc/timezone

3. run ```sudo dpkg-reconfigure --frontend noninteractive``` tzdata:

```
$ echo "Asia/Shanghai" | sudo tee /etc/timezone
Australia/Adelaide
$ sudo dpkg-reconfigure --frontend noninteractive tzdata

Current default time zone: 'Australia/Adelaide'
Local time is now:      Sat May  8 21:19:24 CST 2010.
Universal Time is now:  Sat May  8 11:49:24 UTC 2010.
```

This can be scripted if required.


### NTP

```
$ timedatectl status
      Local time: Tue 2017-03-07 03:35:20 CST
  Universal time: Mon 2017-03-06 19:35:20 UTC
        RTC time: Mon 2017-03-06 19:35:20
       Time zone: Asia/Shanghai (CST, +0800)
 Network time on: yes
NTP synchronized: yes
 RTC in local TZ: no
```











## iptables

若 INPUT 链预设是 DROP 或者 INPUT 链最后的规则只有 **-j DROP**，则必须在这条规则之前添加：

```
$ sudo iptables -I INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
```

否则，Ubuntu 不能使用 **apt-get** 更新。


使用 **iptables-save**，必须像下面这样：

```
$ sudo sh -c "iptables-save > /etc/iptables.rules"
```
