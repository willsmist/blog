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
