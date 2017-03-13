---
title: 使用二进制包安装 MySQL (未解决)
date: 2017-03-03 23:21:26
tags:
categories:
---

安装 MySQL,仍有一些启动问题未解决，先不研究了

<!--more-->

---

## 获取 MySQL 安装包

强烈建议对下载的安装包进行验证。

## 在 Linux 上安装

https://dev.mysql.com/doc/refman/5.7/en/binary-installation.html

### 使用通用二进制包安装

>Warning

>If you have previously installed MySQL using your operating system native package management system, such as yum or apt-get, you may experience problems installing using a native binary. Make sure your previous MySQL installation has been removed entirely (using your package management system), and that any additional files, such as old versions of your data files, have also been removed. You should also check for configuration files such as /etc/my.cnf or the /etc/mysql directory and delete them.

<br/>

>Warning

>MySQL has a dependency on the **libaio** library. Data directory initialization and subsequent server startup steps will fail if this library is not installed locally. If necessary, install it using the appropriate package manager. For example, on Yum-based systems:

>```
shell> yum search libaio  # search for info
shell> yum install libaio # install library
```

>Or, on APT-based systems:

>```
shell> apt-cache search libaio # search for info
shell> apt-get install libaio1 # install library
```

**MySQL Installation Layout for Generic Unix/Linux Binary Package**

Directory | Contents of Directory
---|---
bin, scripts | mysqld server, client and utility programs
data	| Log files, databases
docs	| MySQL manual in Info format
man	| Unix manual pages
include	| Include (header) files
lib	| Libraries
share	| Miscellaneous support files, including error messages, sample configuration files, SQL for database installation


对于 5.7.17 版本，文件 my-default.cnf 位于 MYSQL_INSTALLATION_DIR/support-files目录下。
如果需要 my.cnf ，可从该目录下获得模板文件。

>Default options are read from the following files in the given order:
/etc/my.cnf /etc/mysql/my.cnf /usr/local/mysql/etc/my.cnf ~/.my.cnf

```
shell> groupadd mysql
shell> useradd -r -g mysql -s /bin/false mysql
shell> cd /usr/local
shell> tar zxvf /path/to/mysql-VERSION-OS.tar.gz
shell> ln -s full-path-to-mysql-VERSION-OS mysql
shell> cd mysql
shell> mkdir mysql-files
shell> chmod 750 mysql-files
shell> chown -R mysql .
shell> chgrp -R mysql .
shell> scripts/mysql_install_db --user=mysql# MySQL 5.7.0 to 5.7.4
shell> bin/mysql_install_db --user=mysql    # MySQL 5.7.5
shell> bin/mysqld --initialize --user=mysql # MySQL 5.7.6 and up
shell> bin/mysql_ssl_rsa_setup              # MySQL 5.7.6 and up
shell> chown -R root .
shell> chown -R mysql data mysql-files
shell> bin/mysqld_safe --user=mysql & #必须在 base_dir 下执行才能启动 mysql
# Next command is optional
shell> cp support-files/mysql.server /etc/init.d/mysql.server
```

>**Note**

>This procedure assumes that you have root (administrator) access to your system. Alternatively, you can prefix each command using the **sudo** (Linux) or pfexec (OpenSolaris) command.


## 连接远程的 mysql 数据库

修改远程数据库服务器中名为 mysql 的数据库中的 user 表的 host 字段的值。

可以直接使用 update 语句，将 mysql.user 表中指定 <user> 字段的对应的记录中的 <host> 字段修改为指定的 IP 地址:

```
mysql> USE mysql;
mysql> UPDATE user SET host = '192.168.1.2' WHERE user = 'root';
mysql> SELECT host, user FROM user;
```

但是这样就无法在本地登录该账户了，最好使用 GRANT 语句：

```
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'youpassword' WITH GRANT OPTION;

mysql> GRANT SELECT,INSERT,UPDATE,DELETE ON *.* TO 'root'@'202.11.10.253' IDENTIFIED BY "dboomysql";
```

给我自己的机器(192.168.1.2)上 mysql 的 root 用户在 192.168.1.10 登录的权限：

```
mysql> GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.1.10' IDENTIFIED BY '648502' WITH GRANT OPTION;
mysql> SELECT user,host FROM mysql.user;
+-----------+--------------+
| user      | host         |
+-----------+--------------+
| root      | 192.168.1.10 |
| mysql.sys | localhost    |
| root      | localhost    |
+-----------+--------------+

```

注意 localhost 等于 127.0.0.1，localhost 不等于本机当前 IP 地址 192.168.1.2，这应该可以在 hosts 中设置，但这样设置应该不妥，因为192.168.1.2 是可变的。


## SSH Tunnel\(隧道\)连接 MySQL

```
mysql> SELECT user,host FROM mysql.user;
+-----------+--------------+
| user      | host         |
+-----------+--------------+
| root      | 192.168.1.10 |
| mysql.sys | localhost    |
| root      | localhost    |
+-----------+--------------+

```

* 本机登录：root@localhost 是 mysql 安装时建立的，密码：123456
* 远程登录：root@192.168.1.10 是远程连接 mysql 时建立的，密码：654321

场景：用户位于 机器 S(localhost)，数据库实例在机器 D 上，由于网络隔离的原因，用户无法直接访问机器 D。但是用户可以通过 SSH 访问机器 M，并且机器 M 能够访问机器 D 上的数据库实例。因此可以考虑将 M 作为跳板，使用 SSH 隧道技术，使用户在机器 S 上可以访问机器 D 上的数据库。

模拟该场景需要三台机器，但我只有两台，而且也没有可用的虚拟机，怎样才能模拟呢？

在命令行登录 mysql 时， -h 选项指定数据库所在地址。虽然 127.0.0.1 和 192.168.1.2(本机在局域网的IP) 是同一台机器，但使用 **-h 127.0.0.1** 和 **-h 192.168.1.2** 去登录mysql是不同的。所以正常情况下,使用最初安装mysql时建立的root账户使用 **-h 192.168.1.2** 是无法在本机登录的，正如上面所说，这个 root 账户其实是位于 127.0.0.1 的。因此，可以将 192.168.1.2 作为场景中的机器 D，用户在本机(-h 127.0.0.1)访问本机(-h 192.168.1.2)上的数据库实例，将 192.168.1.10 作为机器 M 。

```
$ mysql -h 127.0.0.1 -u root -p123456 #登录成功

$ mysql -h 192.168.1.2 -u root -p123456 #登录失败
```

* S - 127.0.0.1(本机)

* D - 192.168.1.2(本机)

* M - 192.168.1.19

建立 SSH 隧道

```
$ ssh -fN -L 3308:192.168.1.2:3306 -p 6485 will@192.168.1.10
```

用 netstat 查看，SSH 进程在后台监听 3308 端口：

```
will@massif:~$ netstat -ptln
(Not all processes could be identified, non-owned process info
 will not be shown, you would have to be root to see it all.)
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name
tcp        0      0 127.0.0.1:8080          0.0.0.0:*               LISTEN      -               
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      -               
tcp        0      0 127.0.1.1:53            0.0.0.0:*               LISTEN      -               
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -               
tcp        0      0 0.0.0.0:25              0.0.0.0:*               LISTEN      -               
tcp        0      0 0.0.0.0:8060            0.0.0.0:*               LISTEN      -               
tcp        0      0 127.0.0.1:3308          0.0.0.0:*               LISTEN      24908/ssh       
tcp6       0      0 :::22                   :::*                    LISTEN      -               
tcp6       0      0 :::25                   :::*                    LISTEN      -               
tcp6       0      0 :::3306                 :::*                    LISTEN      -               
tcp6       0      0 ::1:3308                :::*                    LISTEN      24908/ssh
```

使用 lsof 查看端口：

```
will@massif:~$ lsof -i :3308
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
ssh     24908 will    5u  IPv6 136164      0t0  TCP ip6-localhost:3308 (LISTEN)
ssh     24908 will    6u  IPv4 136165      0t0  TCP localhost:3308 (LISTEN)
```


```
$ mysql -h 127.0.0.1 -P 3308 -u root -p654321 #从这里的密码可知，用的是 root@192.168.1.10 登录的
```

直接访问本地的 3308 端口，就实现了登录

应该是这样的：创建mysql账户时，用户名、密码是与 host 地址绑定的，而通过 SSH 隧道转发到机器 D 的数据在登录时只用到了用户名和密码，而 host 使用的是跳板机器 M 的地址，所以只能用机器 D 数据库保存的账户信息中 host 为 192.168.1.10 的用户登录。所以对上述场景的模拟并不很合适，但确实实现了本机 mysql 客户端借助中间机器访问本机数据库实例的目的。


登录数据库后再用 lsof 查看进程
```
will@massif:~$ lsof -i :3308
COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
ssh     24908 will    5u  IPv6 136164      0t0  TCP ip6-localhost:3308 (LISTEN)
ssh     24908 will    6u  IPv4 136165      0t0  TCP localhost:3308 (LISTEN)
ssh     24908 will    7u  IPv4 142973      0t0  TCP localhost:3308->localhost:10252 (ESTABLISHED)
mysql   26181 will    3u  IPv4 141312      0t0  TCP localhost:10252->localhost:3308 (ESTABLISHED)
```

















$ mysql -h127.0.0.1 -P3308 -uroot -p648502
