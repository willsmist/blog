---
title: Apache Troubleshooting
date: 2017-02-21 15:01:22
tags:
- Apache
categories:
- Technique
- Apache
---

使用 Apache 服务器过程中遇到的各种问题，在此记录以供参考。

<!--more-->

---

* Forbidden
  You don't have permission to access / on this server.
  Server unable to read htaccess file, denying access to be safe

  可能是由于 Apache 服务器没有权限访问 `DocumentRoot`、`<Directory>`所设置的目录，检查该目录的权限。
  不仅仅是检查最终目录的权限，还要检查整个 Path 中包含的各级目录的权限，最后修改权限使 Apache 可访问即可。

* Apache 列目录中文文件名乱码

  在文件 httpd.conf 中添加 `IndexOptions Charset=UTF-8`，然后重启 Apache 应该正常显示中文了。
