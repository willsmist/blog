---
title: Ubuntu 服务器初始配置(未完)
date: 2017-08-17 20:09:59
tags:
- Linux
- Ubuntu
- SSH
- iptables
categories:
- Technique
- Linux
---

Ubuntu Server 全新安装后需要进行一系列的配置才能满足需求，本文包括用户创建、SSH 公钥登录、防火墙、网卡以及关闭笔记本盖子不休眠等配置。

<!-- more -->

# 首次远程登录

使用 SSH 协议远程登录服务器，打开终端输入:

```bash
$ ssh will@192.168.1.6
The authenticity of host '192.168.1.6 (192.168.1.6)' can't be established.
ECDSA key fingerprint is SHA256:5IAZ3plPrlqyufODHzyo5TlrO8DVzeu/8NUbgVdsRns.
Are you sure you want to continue connecting (yes/no)?
```

第一次 SSH 远程登录服务器会出现主机的真实性无法确认的警告，并提供了主机公钥的类型(ECDSA)和指纹信息(SHA256)。

* `ECDSA` 表明远程主机发送过来的公钥保存在远程主机的 `/etc/ssh/ssh_host_ecdsa_key.pub` 文件中

* `SHA256` 表示公钥指纹是由 SHA256 算法生成的

*如果能本地登录到服务器，那么可以查看服务器的公钥指纹:*

```bash
$ sudo ssh-keygen -l -f /etc/ssh/ssh_host_ecdsa_key
256 SHA256:5IAZ3plPrlqyufODHzyo5TlrO8DVzeu/8NUbgVdsRns root@icarus (ECDSA)
$ sudo ssh-keygen -l -f /etc/ssh/ssh_host_ecdsa_key.pub
256 SHA256:5IAZ3plPrlqyufODHzyo5TlrO8DVzeu/8NUbgVdsRns root@icarus (ECDSA)
```

注意，指纹默认是 SHA256，可以用 `-E md5` 选项来显示 MD5 指纹。

*可以看到，`ssh-keygen` 使用私钥和公钥查看指纹的结果是一样的。通过对比公钥指纹是否一致来验证远程主机的真实性。*

远程主机的真实性得到确认后就输入 `yes` ，会将该主机的公钥保存到本机文件 `~/.ssh/known_hosts` 中，下次远程登录该主机就无需再次确认主机的真实性。
最后输入用户的密码则登录成功。

# 创建用户

由于 Ubuntu 不提供 root 用户登录，可以直接使用安装系统时创建的用户，而不必另行创建作为管理员的新用户

* 创建用户组

    ```bash
    $ sudo groupadd dev
    ```

    此处不要创建 admin 用户组，因为 Ubuntu 系统中 admin 在 sudoers 文件中已有定义,因此该组用户将自动具有 sudo 权限。

* 创建用户

  ```bash
  $ sudo useradd -m -d /home/bill -s /bin/bash bill
  ```

    * -d, --home-dir HOME_DIR 将 HOME_DIR 指定为用户的登录目录(仅仅是指定并不会创建)
    * -m 如果用户家目录不存在则创建
    * -s, --shell SHELL 用户登录 shell 的名称

* 为新用户设置密码

  ```terminal
  $ sudo passwd bill
  ```

* 将新用户添加到用户组

  ```terminal
  $ sudo usermod -a -G admin bill
  ```

* 设置 sudo 权限

  ```terminal
  $ sudo visudo
  ```

  在 `root    ALL=(ALL:ALL) ALL` 下面添加

  ```config
  bill    ALL=(ALL:ALL) ALL
  ```

  注：使用 `sudo -l` 可以查看当前用户的 sudo 权限

最后退出登录，使用新建用户 bill 登录，检查是否成功。

# SSH 公钥登录

所谓"公钥登录"，原理很简单，就是用户将自己的公钥储存在远程主机上。登录的时候，远程主机会向用户发送一段随机字符串，用户用自己的私钥加密后，再发回来。远程主机用事先储存的公钥进行解密，如果成功，就证明用户是可信的，直接允许登录shell，不再要求输入密码。

假设本机已有 SSH 密钥并位于 `~/.ssh` 目录下，执行下面的命令:

```bash
$ cat ~/.ssh/id_rsa.pub | ssh user@<address> 'mkdir -p .ssh && cat - >> ~/.ssh/authorized_keys'
```

使用密码远程登录服务器，修改 `~/.ssh` 和 `~/.ssh/authorized_keys` 的权限

```bash
$ sudo chmod 700 ~/.ssh
$ sudo chmod 600 ~/.ssh/authorized_keys
```

备份并修改服务器 SSH 配置文件 `/etc/ssh/sshd_config`

```text
Port 2222

Protocol 2

PermitRootLogin no

RSAAuthentication yes
PubkeyAuthentication yes
AuthorizedKeysFile      .ssh/authorized_keys

PermitEmptyPasswords no
PasswordAuthentication no
```

以上主要是禁止 root 用户登录和密码方式登录。

也可以在配置文件的末尾，指定允许登陆的用户：

```text
AllowUsers bill
```

重启 SSH 服务

```bash
$ sudo /etc/init.d/ssh restart
[ ok ] Restarting ssh (via systemctl): ssh.service.
```

登出服务器，再次远程登录则不需要输入密码，而且也不可能使用密码登录了，因为被禁止了。

下面的一步是可选的。在本机~/.ssh文件夹下创建config文件，内容如下。

```text
Host icarus
HostName 192.168.1.6
User bill
Port 2222
```

这样就可以简化命令:

```bash
$ ssh icarus
```

# 系统更新

使用 `apt` 相应命令进行系统更新

```bash
$ sudo apt-get update
$ sudo apt-get dist-upgrade
```

## 关闭笔记本盖子不休眠

```bash
$ sudo vim /etc/systemd/logind.conf
```

修改为如下配置:

```text
HandleLidSwitch=ignore
```

重启 Login Manager 服务

```bash
$ sudo systemctl restart systemd-logind.service
```
