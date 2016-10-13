---
title: Hexo 指南
date: 2016-09-10 13:19:53
tags:
- Hexo
categories:
- Technique
- Hexo
---
[Hexo](https://hexo.io "Hexo's Homepage") 是一个快速、简洁且高效的基于 [Node.js](https://nodejs.org "Node.js's Homepage") 的静态博客框架，作者是 [**Tommy Chen**](https://zespia.tw/)。

<!-- more -->

## Hexo 的优势

Node.js 所带来的超快生成速度，可以让上百个页面在几秒内瞬间完成渲染；Hexo 支持 GitHub Flavored Markdown 的所有功能，使用喜欢的文本编辑器就可以进行写作；其命令操作也很简洁，只需一条指令即可部署到 GitHub Pages, Heroku 或其他网站。

## GitHub Pages

使用 Hexo 创建的博客网站，可以托管在 [GitHub Pages](https://help.github.com/articles/what-is-github-pages/) 所提供的空间中。
GitHub Pages 是一个静态网站托管服务，可用于托管在Github仓库中的个人、组织或者项目的静态网页，支持绑定自定义的域名。

## Quickstart

### 安装

安装前，必须确保电脑中已安装 [Node.js](https://nodejs.org "Node.js's Homepage") 和 [Git](https://git-scm.com/ "Git's Homepage")。如果已经安装，只需要执行下列命令就完成了 Hexo 的安装。

```
$ npm install -g hexo-cli
```

### 建站
安装 Hexo 完成后，执行下列命令，Hexo 将会在指定目录中新建所需要的文件。

```
$ hexo init <directory>
$ cd <directory>
$ npm install
```

初始化完成后，目录结构如下：

```
.
├── _config.yml
├── package.json
├── scaffolds
├── source
|   ├── _drafts
|   └── _posts
└── themes
```
各目录及文件的说明请点击 [这里](https://hexo.io/zh-cn/docs/setup.html)，其中 \_config.yml 是网站配置文件。

### 本地运行

执行下列命令，然后在浏览器地址栏访问 http://localhost:4000，就可以在本地预览网站

```
$ hexo server
```

## 将网站部署到 GitHub Pages

1. 首先注册 GitHub 账号，然后配置 SSH keys。其中 SSH keys 的配置请点击[这里](https://help.github.com/articles/generating-an-ssh-key/)
按照其说明就可以轻松完成。

2. 创建一个名称为 <username>.github.io 的仓库,确保该仓库有一个 master 分支。

3. 执行下列命令以安装 hexo-deployer-git,别忘了 --save 选项。

  ```
  $ npm install hexo-deployer-git --save
  ```

4. 使用下列命令将博客部署到 GitHub Pages

  ```
  $ hexo clean && hexo generate && hexo deploy && hexo clean
  ```
  或者使用简写形式：

  ```
  $ hexo cl && hexo g && hexo deploy && hexo cl
  ```

  * hexo clean :清除缓存文件 (db.json) 和已生成的静态文件 (public)
  * hexo generate :生成静态文件
  * hexo deploy :部署网站

以上步骤完成后，在浏览器地址栏访问 https://<username>.github.io 就能访问刚刚建立的博客了。

这篇文章只是一个 Quickstart,用来记录我的学习过程,更多内容请访问 Hexo 的官网。
