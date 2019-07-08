---
title: Ubuntu Troubleshooting (持续更新)
date: 2016-11-5 14:42:18
tags:
- Linux
- Ubuntu
categories:
- Technique
- Linux
---
本文列出了在使用 Ubuntu 过程中遇到的问题，并给出了解决方法，仅供参考。

<!--more-->

---

* 如何使 Ubuntu 包管理器能够管理从源码安装的软件?

  使用一个叫做 checkinstall 的软件，可以通过 apt-get 安装。使用 checkinstall 代替 make install 进行安装。
