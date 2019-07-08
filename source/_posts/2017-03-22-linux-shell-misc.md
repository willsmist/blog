---
title: Shell 随记
date: 2017-03-22 12:43:53
tags:
- Shell
- Linux
categories:
- Technique
- Linux
- Shell
---

shell 碎片笔记

<!--more-->

---
* awk 执行步骤：
  1. 读取第一整行
  2. 根据分隔符进行赋值
  3. 执行单引号 '' 里的的条件和动作
  4. 循环以上3个步骤，处理下一行

  BEGIN 表示以上所有步骤执行前执行 BEGIN后的动作,例如:awk 'BEGIN{FS=":"} FILENAME'，表示设置分隔符

* 通过 `make install` 的输出内容查看编译安装的目录和文件，例如: `cat httpd_make_install.log | grep "mkdir"`

* basename URL: 可以获取下载文件名

* 变量名含有下划线，使用 $ 调用时必须加双引号, 或者判断表达式使用双中括号括起来

* `. filename` 和 `source filename` 表示包含文件

参考：http://opus.konghy.cn/shell-tutorial/chapter7.html#shell_2

像其他语言一样，Shell 也可以包含外部脚本，即将外部脚本的内容合并到当前脚本。其包含脚本的方法有两种，即 “.” 和 “source” 。

被包含脚本不需要有执行权限，只保持主脚本有执行权限即可。Shell 在执行脚本时是另外开启一个子进程来执行的，所以想要让脚本的内容在当前 shell 中执行，则需要用 “.” 或 “source” 来执行脚本。其实这这两者的含义是一样的，所谓的让脚本内容在当前 shell 执行，也就是将脚本文件的内容包含到当前 shell 来执行，其实质都是文件包含。
