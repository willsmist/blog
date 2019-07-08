---
title: UEFI 安装 Windows 10,Fedora 24 & Ubuntu 16.04
date: 2016-09-14 17:29:05
tags:
- Linux
- Windows
categories:
- Technique
- Linux
---

将这三个系统安装到同一台电脑上并不难，难的是达到身患强迫症的笔者的要求，还是要折腾不少，我已经记不清重装了多少次了(没办法，患有强迫症的小白解决问题的方法只有重装)。虽然这其中经历了各种苦不堪言，但是对于所获得的知识和道理，那又算得了什么呢？

<!--more-->

---

# 写在前面

Windows 是多数普通人最熟悉的桌面操作系统，而且很多事情对笔者来说也是离不开的。选择 Ubuntu 和 Fedora ，是因为 Ubuntu 是 Linux 中比较火的桌面操作系统，其网络上的资源非常丰富，基本上没有 Google 解决不了的问题，这也是笔者将 Ubuntu 作为主 Lunux 系统的原因之一。至于 Fedora 嘛，据说Linux 的缔造者 Linus 都在使用，当然要安装它了,还有一部分原因是 Fedora 和 Ubuntu 使用的是不同的包管理系统，这也是出于学习 Linux 的考虑。

# 安装前提

本节的所有操作是在 Windows 10 上完成的。

* 备份、备份、备份，重要的事情说三遍。
* 假定已经 UEFI 安装 Windows 10，Windows 的安装就不赘述了。需要注意的是电脑的启动方式设置为 UEFI，并且在“选择安装位置”这一步时要删除全部分区，再重新分区，应该只有这样才能使硬盘分区格式从 MBR 转换为 GPT。当然也可以 `Shift+F10` 开启命令行窗口，使用 `diskpart` 进行这一步。
* 下载 [Fedora 24 Workstation Live](https://getfedora.org/en/workstation/download/) 镜像文件
* 下载 [Ubuntu 16.04 LTS Desktop](http://www.ubuntu.com/download/desktop) 镜像文件

有了以上文件，就可以开始制作 Fedora 和 Ubuntu 的可启动U盘了，需要说明的是 Fedora 24 的官方安装说明 [Installation Guide](https://docs.fedoraproject.org/en-US/Fedora/24/html/Installation_Guide/sect-preparing-boot-media.html)推荐使用 [SUSE Studio ImageWriter](https://github.com/downloads/openSUSE/kiwi/ImageWriter.exe) 或 [Rawrite32](http://www.netbsd.org/~martin/rawrite32/)，笔者选择的是 Rawrite32。对于 Ubuntu 笔者使用的是 [Rufus](http://rufus.akeo.ie/)。

**如果使用 Rawrite32 使得U盘空间不可用，请参考这篇文章：[How To Use DiskPart Command To Recover Missing Or Unallocated Space On A USB Drive](http://www.ampercent.com/recover-lost-space-removable-usb-drive/9352/)**

# 开始安装

对于具体的安装过程，本文只是一笔带过，图形界面安装过程实在是太简单了(笔者并不会字符界面安装 Linux)。

## 安装 Fedora

先安装 Fedora ，是因为笔者想用 Ubuntu 作为默认引导的系统。通过最后安装 Ubuntu 以最少的配置来实现这一点，这样就可以不用或者更少地修改 grub 配置。

使电脑从可启动U盘启动，进入 Fedora 安装界面，根据需要进行设置，设置完成就可以点击开始安装进行安装了，详细过程不赘述。重启后安装完成，进行必要的系统更新和软件安装等等。

需要注意的是，安装 Fedora 24 之前并没有关闭安全启动，这可能是新版本的 Fedora 进行的兼容。

## 安装 Ubuntu

首先要在 BIOS 设置中关闭安全启动，否则会出现即便正确安装了驱动程序，Nvidia 显卡也不能正常工作，结果就是显卡一直处于较高的温度，风扇转的很快,噪音也很大。

然后使电脑从可启动U盘启动，进入 Ubuntu 安装界面，根据需要进行设置，详细过程不赘述。重启后安装完成，进行必要的系统更新和软件安装等等。

# 关于显卡驱动程序

首先吐槽一下，Nvidia 显卡驱动程序真***(此处省略很多字)，估计这是安装 Linux 最难的地方了。由于笔者笔记本电脑的 Nvidia 显卡具备 Optimus 技术，所以在 Fedora 24 下安装 Linux 版本的显卡驱动始终不能成功。而 Ubuntu 16.04 完全不必担心，因为 Ubuntu 的官方软件库提供了显卡驱动程序，而且可以在 Intel 显卡和 Nvidia 显卡间自由切换。

此时笔记本的状态是：

# 总结

遇到问题不可怕，可怕的是迟迟找不到正确的解决方案，究其原因还是寻找解决方案的方式途径出了问题。在学会科学上网之前，那就是"有问题找度娘"，结果大多是各种抄袭成风、以讹传讹的博客文章。自从着了科学上网的道，Google、Stack Overflow 等成为我解决问题的首选，而且问题确实很快解决了，这要感谢对 Linux 的折腾。