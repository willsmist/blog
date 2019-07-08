---
title: SVN 编译安装
date: 2017-03-12 00:45:22
tags:
- Subversion
- SVN
- VCS
categories:
- Technique
- SVN
---
subversion 安装

<!--more-->

---

## 服务器端

### 编译安装 Apache

执行 ```$ ./buildconf``` 需要提前安装 autoconf 软件包

```
$ ./buildconf

$ ./configure --prefix=/usr/local/httpd-2.4.25
--with-apr=/usr/local/apr
--with-apr-util=/usr/local/apr-util
--with-pcre=/usr/local/pcre
--enable-so
--enable-ssl
--with-ssl=/usr/local/openssl-1.0.2k
--enable-dav  #构建 mod_dav
--enable-maintainer-mode
```

>The --enable-so arg says to enable shared module support which is needed
      for a typical compile of mod_dav_svn

>The --enable-dav arg says to build mod_dav.

>The --enable-maintainer-mode arg says to include debugging information.  If you
      built Subversion with --enable-maintainer-mode, then you should
      do the same for Apache; there can be problems if one was
      compiled with debugging and the other without.

### 编译安装 Subversion

先把 sqlite-amalgamation 复制到 subversion 目录下

```
$ ./configure --prefix=/usr/local/subversion-1.9.5 --with-apr=/usr/local/apr --with-apr-util=/usr/local/apr-util --with-apxs=/usr/local/apache2/bin/apxs --enable-maintainer-mode
```

报错:

```
configure: zlib library configuration via pkg-config
configure: zlib library configuration
checking zlib.h usability... no
checking zlib.h presence... no
checking for zlib.h... no
configure: error: subversion requires zlib

```

安装 zlib1g-dev

```
$ sudo apt-get install zlib1g-dev
```

再执行 configure 不再报错。

## 配置

### svnserve

```
$ svnserve -d  #启动 svnserve 服务器，并作为守护进程运行
```

 * -r 可指定访问版本库的根目录
