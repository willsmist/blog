---
title: Hexo 部分问题解决办法(持续更新)
date: 2016-09-26 13:36:32
tags:
- Hexo
categories:
- Technique
- Hexo
---
本文列出了我在使用 Hexo 过程中遇到的问题以及解决办法。

<!--more-->

---

### Markdown 语法中的引用 ">" ,不能正常显示。
  这可能是当前安装的主题造成的，换个主题试试。因为相同的 Markdown 语法在不同的主题中表现可能不一样。

### 使用 `$ hexo deploy` 不能部署网站。
  检查目录 /node_modules ，是否安装了 hexo-deployer-git。如果还不能解决问题，执行下列命令再安装一次：

  ```terminal
 $ npm install hexo-deployer-git --save
  ```

  别忘了 --save 选项。

### 如何防止 /source 目录下的 README.md 文件被渲染？
  在网站配置文件 \_config.yml 中搜索 **skip_render**,其值设置为 README.md。

### 对于自定义域名，CNAME 文件总在网站部署后被覆盖。
  在 /source 目录下新建文件 CNAME，添加自定义的域名保存即可。

### 如何在 Markdown 中使用注释, 使其在渲染的时候忽略。
  可以使用如下格式:

  ```
  [comment]: # (这里是注释)
  ```

  或者

  ```
  [//]: # (这里是注释)
  ```

  注释行前后都要有空行
  其他注释方法可参考:http://stackoverflow.com/questions/4823468/comments-in-markdown
