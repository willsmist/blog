---
title: 使用 Hexo 创建静态博客
date: 2016-09-10 13:19:53
tags:
- Hexo
categories:
- Technique
- Hexo
---

[Hexo](https://hexo.io "Hexo's Homepage") 是一个快速、简洁且高效的基于 [Node.js](https://nodejs.org "Node.js's Homepage") 的静态博客框架，支持 GitHub Flavored Markdown 的所有功能，其命令操作也很简洁，只需一条指令即可部署到 [GitHub Pages](https://help.github.com/articles/what-is-github-pages/)，Heroku 或其他网站。本文将简单地演示使用 Hexo 框架创建一个博客网站，并将其托管在 Github Pages 上。

<!-- more -->

# 安装

首先要确保系统已安装 [Node.js](https://nodejs.org "Node.js's Homepage") 和 [Git](https://git-scm.com/ "Git's Homepage")。然后，只需要执行下列命令就完成了 Hexo 的安装。

```bash
$ npm install -g hexo-cli
```

# 建站

安装 Hexo 完成后，执行下列命令，Hexo 将会在指定目录中新建所需要的文件。

```bash
$ hexo init <directory>
$ cd <directory>
$ npm install
```

使用 `hexo init` 初始化完成后，目录结构如下：

```bash
.
├── _config.yml
├── package.json
├── scaffolds
├── source
|   ├── _drafts
|   └── _posts
└── themes
```

各目录及文件的说明请点击 [这里](https://hexo.io/zh-cn/docs/setup.html)，其中 `_config.yml` 是网站配置文件。

而 `npm install` 则是执行安装 Hexo 所需的依赖。

执行命令 `hexo server`，然后在浏览器地址栏访问 `http://localhost:4000` ，就可以在本地预览刚刚创建的网站。

# 部署

按照以下步骤可以将上面创建的博客网站托管到 Github Pages。

1. 注册 GitHub 账号，然后配置 SSH keys。其中 SSH keys 的配置请点击[这里](https://help.github.com/articles/generating-an-ssh-key/)
   按照其说明就可以轻松完成。

2. 创建名称为 `<username>.github.io` 的仓库,确保该仓库有一个 master 分支。其中，需要将 `<username>` 替换为 Github 用户名。

3. 安装 hexo-deployer-git，别忘了 `--save` 选项。

   ```bash
   $ npm install hexo-deployer-git --save
   ```

4. 使用下列命令将博客部署到 GitHub Pages

   ```bash
   $ hexo clean && hexo generate && hexo deploy && hexo clean
   ```
   或者使用简写形式：

   ```bash
   $ hexo cl && hexo g && hexo deploy && hexo cl
   ```

   说明：

   `hexo clean` 清除缓存文件(db.json)和已生成的静态文件(public)
   `hexo generate` 生成静态文件
   `hexo deploy` 部署网站

以上步骤全部完成后，在浏览器访问 `https://<username>.github.io` (`<username>` 替换为 Github 用户名) 就能浏览刚刚托管在 Github Pages 上的网站。

这篇文章只是一个简单演示，以记录初次使用 Hexo 创建博客站点的过程，更多内容请访问 [Hexo](https://hexo.io "Hexo's Homepage") 的官网。
