---
title: Apache 服务器编译安装
date: 2017-03-08 21:34:27
tags:
- Apache
categories:
- Technique
- Apache
---

一些手记

<!--more-->

---

## apache
编译 Apache httpd-2.4.25，使用 openssl-1.1.0e 出现如下所示的错误：

```
ab.o: In function `main':
/usr/local/httpd-2.4.25/support/ab.c:2468: undefined reference to `CRYPTO_malloc_init'
/usr/local/httpd-2.4.25/support/ab.c:2398: undefined reference to `SSLv2_client_method'
collect2: ld returned 1 exit status
make[2]: *** [ab] Erreur 1
make[2]: quittant le répertoire « /opt/httpd-2.4.25/support »
make[1]: *** [all-recursive] Erreur 1
make[1]: quittant le répertoire « /opt/httpd-2.4.25/support »
make: *** [all-recursive] Erreur
```

把 opensll 版本换成 openssl-1.0.2k 可以使编译通过。


## 安装 windows 服务



## mysql

需要安装 libaio (YUM) 或 libaio1 (APT)

```
bin/mysqld: error while loading shared libraries: libaio.so.1: cannot open shared object file: No such file or directory
```


### windows

使用 mysqladmin 的 variables 命令可以查看

```
Default options are read from the following files in the given order:
C:\Windows\my.ini C:\Windows\my.cnf C:\my.ini C:\my.cnf C:\Software\mysql\mysql-5.7.17\my.ini C:\Software\mysql\mysql-5.7.17\my.cnf
```

安装为服务：https://dev.mysql.com/doc/refman/5.7/en/windows-start-service.html
