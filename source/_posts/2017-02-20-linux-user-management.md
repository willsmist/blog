---
title: Linux 用户管理
date: 2017-02-20 20:45:55
tags:
categories:
---

note +manual.
<!--more-->

---

用户：使用操作系统的人
用户组：具有相同系统权限的一组用户


文件 /etc/group 存储当前系统中所有用户组信息，每一行对应一个用户组的信息，每一行都是被3个冒号分成4部分

```
root:x:0:
bin:x:1:bin,daemon
daemon:x:2:bin,daemon
sys:x:3:bin,adm
...
...
sshd:x:74:
ygl:x:500:
```

遵循这样的格式：[group_name]:[group_password_tab]:[group_id]:[users_list]或[组名称]:[组密码占位符]:[组编号]:[组中用户名列表]

[users_list] 为空不表示没有用户，当该用户组只有一个用户并且用户名和用户组名相同时可以在[users_list]中省略

下面几点是所有 Linux 都具备的
* Linux 中，root 用户组 ID 一定是0
* 1-499 是系统预留 ID ，用于安装在系统中的软件和服务，把未被使用的最小 ID 分配给最早安装的软件和服务
* 用户手动创建的用户组 ID 是从 500 开始的，并把大于等于 500 的未使用的最小的 ID 分配给新创建的用户组
* 组密码占位符无一例外全用 x 表示


文件 /etc/gshadow 存储当前系统中用户组的密码信息

/etc/group 有多少行，/etc/gshadow 就有多少行,一一对应，每一行也是被3个冒号分成4部分

```
root:::
bin:::bin,daemon
daemon:::bin,daemon
sys:::bin,adm
...
...
sshd:!::
ygl:!::
```

格式：[group_name]:[group_password]:[group_mgr]:[users_list] 或 [组名称]:[组真实密码]:[组管理者]:[组用户名列表]

* 组密码为 空 * ! 三者中一个时，认为没有组密码
* 组管理者为空表示没有管理者，组内所有用户都可以对该用户组进行管理
* 组用户名列表与 /etc/group 一致


文件 /etc/passwd 存储当前系统中所有用户的信息

每一行对应一个用户的信息，每一行用冒号分成了 7 部分，分别表示 [用户名]:[密码占位符]:[用户ID]:[用户组ID]:[用户注释信息]:[用户主目录]:[shell类型]

```
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
...
...
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
ygl:x:500:500::/home/ygl:/bin/bash
```

当一个用户被创建时，除了 root 用户，都会在 /home/ 下创建一个与用户名同名的主目录

* 超级管理员 root 用户ID一定是 0


文件 /etc/shadow 存储当前系统中所有用户的密码信息

~~每一行用冒号分成了 7 部分(并不是7部分啊，我的系统是8个冒号分成9部分)~~

```
root:$6$5K3LdG0C0GbJpYhV$p9BDmiqHNd6Y1TfTlRkP7zZ4Vs76rLOxbCY5cu6CQH/QQi7v8YiMCj0T4esCdpThD/gWc/9GZcNiJHY.gHiG/1:17217:0:99999:7:::
bin:*:15980:0:99999:7:::
daemon:*:15980:0:99999:7:::
adm:*:15980:0:99999:7:::
...
...
sshd:!!:17217::::::
ygl:$6$F5nfqxd4$3WSsNmUgEjDJmeiuHuOOCgLaTZbl.t3639p2MauIzzutJ/fBGvM3qUB4ivog0THsN6.qeWTeD78LM1DbZAwK7.:17217:0:99999:7:::
```

其中的密码是真实密码，使用单向加密的方式进行了加密


Linux 早期系统只有 /etc/group 和 /etc/passwd ，密码也是保存在这两个文件。由于这两个文件经常被读取判断用户属于哪个用户组之类的问题，这两个文件的权限不能太苛刻，而密码又是敏感信息，密码信息与之放在一起会不安全，所以增加了 /etc/gshadow 和 /etc/shadow 用于存储密码信息。


删除用户组之前必须先删除该组内的用户，否则用户信息中的用户组信息就无法对应，后续的使用上就会受到权限上的影响。


## 组命令

groupadd  groupmod  groupdel gpasswd newgrp

### groupadd
```
NAME
       groupadd - create a new group

SYNOPSIS
       groupadd [options] group

DESCRIPTION
       The groupadd command creates a new group account using the values specified on the command line plus the default values from the system. The new group will be
       entered into the system files as needed.

OPTIONS
       The options which apply to the groupadd command are:

       -f, --force
           This option causes the command to simply exit with success status if the specified group already exists. When used with -g, and the specified GID already
           exists, another (unique) GID is chosen (i.e.  -g is turned off).

       -g, --gid GID
           The numerical value of the group´s ID. This value must be unique, unless the -o option is used. The value must be non-negative. The default is to use the
           smallest ID value greater than or equal to GID_MIN and greater than every other group.

           See also the -r option and the GID_MAX description.

       -h, --help
           Display help message and exit.

       -K, --key KEY=VALUE
           Overrides /etc/login.defs defaults (GID_MIN, GID_MAX and others). Multiple -K options can be specified.

           Example: -K GID_MIN=100 -K GID_MAX=499

           Note: -K GID_MIN=10,GID_MAX=499 doesn´t work yet.

       -o, --non-unique
           This option permits to add a group with a non-unique GID.

       -p, --password PASSWORD
           The encrypted password, as returned by crypt(3). The default is to disable the password.

           Note: This option is not recommended because the password (or encrypted password) will be visible by users listing the processes.

           You should make sure the password respects the system´s password policy.

       -r, --system
           Create a system group.

           The numeric identifiers of new system groups are chosen in the SYS_GID_MIN-SYS_GID_MAX range, defined in login.defs, instead of GID_MIN-GID_MAX.

       -R, --root CHROOT_DIR
           Apply changes in the CHROOT_DIR directory and use the configuration files from the CHROOT_DIR directory.
```

### groupmod

```  
NAME
       groupmod - modify a group definition on the system

SYNOPSIS
       groupmod [options] GROUP

DESCRIPTION
       The groupmod command modifies the definition of the specified GROUP by modifying the appropriate entry in the group database.

OPTIONS
       The options which apply to the groupmod command are:

       -g, --gid GID
           The group ID of the given GROUP will be changed to GID.

           The value of GID must be a non-negative decimal integer. This value must be unique, unless the -o option is used.

           Users who use the group as primary group will be updated to keep the group as their primary group.

           Any files that have the old group ID and must continue to belong to GROUP, must have their group ID changed manually.

           No checks will be performed with regard to the GID_MIN, GID_MAX, SYS_GID_MIN, or SYS_GID_MAX from /etc/login.defs.

       -h, --help
           Display help message and exit.

       -n, --new-name NEW_GROUP
           The name of the group will be changed from GROUP to NEW_GROUP name.

       -o, --non-unique
           When used with the -g option, allow to change the group GID to a non-unique value.

       -p, --password PASSWORD
           The encrypted password, as returned by crypt(3).

           Note: This option is not recommended because the password (or encrypted password) will be visible by users listing the processes.

           You should make sure the password respects the system´s password policy.

       -R, --root CHROOT_DIR
           Apply changes in the CHROOT_DIR directory and use the configuration files from the CHROOT_DIR directory.  
```

### groupdel

```
NAME
       groupdel - delete a group

SYNOPSIS
       groupdel [options] GROUP

DESCRIPTION
       The groupdel command modifies the system account files, deleting all entries that refer to GROUP. The named group must exist.

OPTIONS
       The options which apply to the groupdel command are:

       -h, --help
           Display help message and exit.

       -R, --root CHROOT_DIR
           Apply changes in the CHROOT_DIR directory and use the configuration files from the CHROOT_DIR directory.
```


## 用户命令

useradd  usermod  userdel  passwd

### useradd

```
NAME
       useradd - create a new user or update default new user information

SYNOPSIS
       useradd [options] LOGIN

       useradd -D

       useradd -D [options]

DESCRIPTION
       When invoked without the -D option, the useradd command creates a new user account using the values specified on the command line plus the default values from the
       system. Depending on command line options, the useradd command will update system files and may also create the new user´s home directory and copy initial files.

       By default, a group will also be created for the new user (see -g, -N, -U, and USERGROUPS_ENAB).

OPTIONS
       The options which apply to the useradd command are:

       -b, --base-dir BASE_DIR
           The default base directory for the system if -d HOME_DIR is not specified.  BASE_DIR is concatenated with the account name to define the home directory. The
           BASE_DIR must exist otherwise the home directory cannot be created.

           If this option is not specified, useradd will use the base directory specified by the HOME variable in /etc/default/useradd, or /home by default.

       -c, --comment COMMENT
           Any text string. It is generally a short description of the login, and is currently used as the field for the user´s full name.

       -d, --home-dir HOME_DIR
           The new user will be created using HOME_DIR as the value for the user´s login directory. The default is to append the LOGIN name to BASE_DIR and use that as the
           login directory name.

       -D, --defaults
           See below, the subsection "Changing the default values".

       -e, --expiredate EXPIRE_DATE
           The date on which the user account will be disabled. The date is specified in the format YYYY-MM-DD.

           If not specified, useradd will use the default expiry date specified by the EXPIRE variable in /etc/default/useradd, or an empty string (no expiry) by default.

       -f, --inactive INACTIVE
           The number of days after a password expires until the account is permanently disabled. A value of 0 disables the account as soon as the password has expired,
           and a value of -1 disables the feature.

           If not specified, useradd will use the default inactivity period specified by the INACTIVE variable in /etc/default/useradd, or -1 by default.

       -g, --gid GROUP
           The group name or number of the user´s initial login group. The group name must exist. A group number must refer to an already existing group.

           If not specified, the behavior of useradd will depend on the USERGROUPS_ENAB variable in /etc/login.defs. If this variable is set to yes (or -U/--user-group is
           specified on the command line), a group will be created for the user, with the same name as her loginname. If the variable is set to no (or -N/--no-user-group
           is specified on the command line), useradd will set the primary group of the new user to the value specified by the GROUP variable in /etc/default/useradd, or
           100 by default.

       -G, --groups GROUP1[,GROUP2,...[,GROUPN]]]
           A list of supplementary groups which the user is also a member of. Each group is separated from the next by a comma, with no intervening whitespace. The groups
           are subject to the same restrictions as the group given with the -g option. The default is for the user to belong only to the initial group.

       -h, --help
           Display help message and exit.

       -k, --skel SKEL_DIR
           The skeleton directory, which contains files and directories to be copied in the user´s home directory, when the home directory is created by useradd.

           This option is only valid if the -m (or --create-home) option is specified.

           If this option is not set, the skeleton directory is defined by the SKEL variable in /etc/default/useradd or, by default, /etc/skel.

           If possible, the ACLs and extended attributes are copied.

       -K, --key KEY=VALUE
           Overrides /etc/login.defs defaults (UID_MIN, UID_MAX, UMASK, PASS_MAX_DAYS and others).

           Example: -K PASS_MAX_DAYS=-1 can be used when creating system account to turn off password ageing, even though system account has no password at all. Multiple
           -K options can be specified, e.g.: -K UID_MIN=100 -K UID_MAX=499

       -l, --no-log-init
           Do not add the user to the lastlog and faillog databases.

           By default, the user´s entries in the lastlog and faillog databases are resetted to avoid reusing the entry from a previously deleted user.

       -m, --create-home
           Create the user´s home directory if it does not exist. The files and directories contained in the skeleton directory (which can be defined with the -k option)
           will be copied to the home directory.

           By default, if this option is not specified and CREATE_HOME is not enabled, no home directories are created.

           The directory where the user´s home directory is created must exist and have proper SELinux context and permissions. Otherwise the user´s home directory cannot
           be created or accessed.

       -M, --no-create-home
           Do not create the user´s home directory, even if the system wide setting from /etc/login.defs (CREATE_HOME) is set to yes.

       -N, --no-user-group
           Do not create a group with the same name as the user, but add the user to the group specified by the -g option or by the GROUP variable in /etc/default/useradd.

           The default behavior (if the -g, -N, and -U options are not specified) is defined by the USERGROUPS_ENAB variable in /etc/login.defs.

       -o, --non-unique
           Allow the creation of a user account with a duplicate (non-unique) UID.

           This option is only valid in combination with the -u option.

       -p, --password PASSWORD
           The encrypted password, as returned by crypt(3). The default is to disable the password.

           Note: This option is not recommended because the password (or encrypted password) will be visible by users listing the processes.

           You should make sure the password respects the system´s password policy.

       -r, --system
           Create a system account.

           System users will be created with no aging information in /etc/shadow, and their numeric identifiers are chosen in the SYS_UID_MIN-SYS_UID_MAX range, defined in
           /etc/login.defs, instead of UID_MIN-UID_MAX (and their GID counterparts for the creation of groups).

           Note that useradd will not create a home directory for such an user, regardless of the default setting in /etc/login.defs (CREATE_HOME). You have to specify the
           -m options if you want a home directory for a system account to be created.

       -R, --root CHROOT_DIR
           Apply changes in the CHROOT_DIR directory and use the configuration files from the CHROOT_DIR directory.

       -s, --shell SHELL
           The name of the user´s login shell. The default is to leave this field blank, which causes the system to select the default login shell specified by the SHELL
           variable in /etc/default/useradd, or an empty string by default.

       -u, --uid UID
           The numerical value of the user´s ID. This value must be unique, unless the -o option is used. The value must be non-negative. The default is to use the
           smallest ID value greater than or equal to UID_MIN and greater than every other user.

           See also the -r option and the UID_MAX description.

       -U, --user-group
           Create a group with the same name as the user, and add the user to this group.

           The default behavior (if the -g, -N, and -U options are not specified) is defined by the USERGROUPS_ENAB variable in /etc/login.defs.

       -Z, --selinux-user SEUSER
           The SELinux user for the user´s login. The default is to leave this field blank, which causes the system to select the default SELinux user.

   Changing the default values
       When invoked with only the -D option, useradd will display the current default values. When invoked with -D plus other options, useradd will update the default
       values for the specified options. Valid default-changing options are:

       -b, --base-dir BASE_DIR
           The path prefix for a new user´s home directory. The user´s name will be affixed to the end of BASE_DIR to form the new user´s home directory name, if the -d
           option is not used when creating a new account.

           This option sets the HOME variable in /etc/default/useradd.

       -e, --expiredate EXPIRE_DATE
           The date on which the user account is disabled.

           This option sets the EXPIRE variable in /etc/default/useradd.

       -f, --inactive INACTIVE
           The number of days after a password has expired before the account will be disabled.

           This option sets the INACTIVE variable in /etc/default/useradd.

       -g, --gid GROUP
           The group name or ID for a new user´s initial group (when the -N/--no-user-group is used or when the USERGROUPS_ENAB variable is set to no in /etc/login.defs).
           The named group must exist, and a numerical group ID must have an existing entry.

           This option sets the GROUP variable in /etc/default/useradd.

       -s, --shell SHELL
           The name of a new user´s login shell.

           This option sets the SHELL variable in /etc/default/useradd.

NOTES
       The system administrator is responsible for placing the default user files in the /etc/skel/ directory (or any other skeleton directory specified in
       /etc/default/useradd or on the command line).
```


### usermod

```
NAME
       usermod - modify a user account

SYNOPSIS
       usermod [options] LOGIN

DESCRIPTION
       The usermod command modifies the system account files to reflect the changes that are specified on the command line.

OPTIONS
       The options which apply to the usermod command are:

       -a, --append
           Add the user to the supplementary group(s). Use only with the -G option.

       -c, --comment COMMENT
           The new value of the user´s password file comment field. It is normally modified using the chfn(1) utility.

       -d, --home HOME_DIR
           The user´s new login directory.

           If the -m option is given, the contents of the current home directory will be moved to the new home directory, which is created if it does not already exist. If
           the current home directory does not exist the new home directory will not be created.

       -e, --expiredate EXPIRE_DATE
           The date on which the user account will be disabled. The date is specified in the format YYYY-MM-DD.

           An empty EXPIRE_DATE argument will disable the expiration of the account.

           This option requires a /etc/shadow file. A /etc/shadow entry will be created if there were none.

       -f, --inactive INACTIVE
           The number of days after a password expires until the account is permanently disabled.

           A value of 0 disables the account as soon as the password has expired, and a value of -1 disables the feature.

           This option requires a /etc/shadow file. A /etc/shadow entry will be created if there were none.

       -g, --gid GROUP
           The group name or number of the user´s new initial login group. The group must exist.

           Any file from the user´s home directory owned by the previous primary group of the user will be owned by this new group.

           The group ownership of files outside of the user´s home directory must be fixed manually.

       -G, --groups GROUP1[,GROUP2,...[,GROUPN]]]
           A list of supplementary groups which the user is also a member of. Each group is separated from the next by a comma, with no intervening whitespace. The groups
           are subject to the same restrictions as the group given with the -g option.

           If the user is currently a member of a group which is not listed, the user will be removed from the group. This behaviour can be changed via the -a option,
           which appends the user to the current supplementary group list.

       -l, --login NEW_LOGIN
           The name of the user will be changed from LOGIN to NEW_LOGIN. Nothing else is changed. In particular, the user´s home directory or mail spool should probably be
           renamed manually to reflect the new login name.

       -L, --lock
           Lock a user´s password. This puts a ´!´ in front of the encrypted password, effectively disabling the password. You can´t use this option with -p or -U.

           Note: if you wish to lock the account (not only access with a password), you should also set the EXPIRE_DATE to 1.

       -m, --move-home
           Move the content of the user´s home directory to the new location. If the current home directory does not exist the new home directory will not be created.

           This option is only valid in combination with the -d (or --home) option.

           usermod will try to adapt the ownership of the files and to copy the modes, ACL and extended attributes, but manual changes might be needed afterwards.

       -o, --non-unique
           When used with the -u option, this option allows to change the user ID to a non-unique value.

       -p, --password PASSWORD
           The encrypted password, as returned by crypt(3).

           Note: This option is not recommended because the password (or encrypted password) will be visible by users listing the processes.

           You should make sure the password respects the system´s password policy.

       -R, --root CHROOT_DIR
           Apply changes in the CHROOT_DIR directory and use the configuration files from the CHROOT_DIR directory.

       -s, --shell SHELL
           The name of the user´s new login shell. Setting this field to blank causes the system to select the default login shell.

       -u, --uid UID
           The new numerical value of the user´s ID.

           This value must be unique, unless the -o option is used. The value must be non-negative.

           The user´s mailbox, and any files which the user owns and which are located in the user´s home directory will have the file user ID changed automatically.

           The ownership of files outside of the user´s home directory must be fixed manually.

           No checks will be performed with regard to the UID_MIN, UID_MAX, SYS_UID_MIN, or SYS_UID_MAX from /etc/login.defs.

       -U, --unlock
           Unlock a user´s password. This removes the ´!´ in front of the encrypted password. You can´t use this option with -p or -L.

           Note: if you wish to unlock the account (not only access with a password), you should also set the EXPIRE_DATE (for example to 99999, or to the EXPIRE value
           from /etc/default/useradd).

       -Z, --selinux-user SEUSER
           The new SELinux user for the user´s login.

           A blank SEUSER will remove the SELinux user mapping for user LOGIN (if any).
```

特别注意：

-G, --groups GROUP1[,GROUP2,...[,GROUPN]]]

***If the user is currently a member of a group which is not listed, the user will be removed from the group. This behaviour can be changed via the -a option,which appends the user to the current supplementary group list.***


### userdel

```
NAME
       userdel - delete a user account and related files

SYNOPSIS
       userdel [options] LOGIN

DESCRIPTION
       The userdel command modifies the system account files, deleting all entries that refer to the user name LOGIN. The named user must exist.

OPTIONS
       The options which apply to the userdel command are:

       -f, --force
           This option forces the removal of the user account, even if the user is still logged in. It also forces userdel to remove the user´s home directory and mail
           spool, even if another user uses the same home directory or if the mail spool is not owned by the specified user. If USERGROUPS_ENAB is defined to yes in
           /etc/login.defs and if a group exists with the same name as the deleted user, then this group will be removed, even if it is still the primary group of another
           user.

           Note: This option is dangerous and may leave your system in an inconsistent state.

       -h, --help
           Display help message and exit.

       -r, --remove
           Files in the user´s home directory will be removed along with the home directory itself and the user´s mail spool. Files located in other file systems will have
           to be searched for and deleted manually.

           The mail spool is defined by the MAIL_DIR variable in the login.defs file.

       -R, --root CHROOT_DIR
           Apply changes in the CHROOT_DIR directory and use the configuration files from the CHROOT_DIR directory.

       -Z, --selinux-user
           Remove any SELinux user mapping for the user´s login.
```


## passwd 修改用户密码

```
NAME
       passwd - update user’s authentication tokens

SYNOPSIS
       passwd [-k] [-l] [-u [-f]] [-d] [-e] [-n mindays] [-x maxdays] [-w warndays] [-i inactivedays] [-S] [--stdin] [username]

DESCRIPTION
       The passwd utility is used to update user’s authentication token(s).

       This  task is achieved through calls to the Linux-PAM and Libuser API.  Essentially, it initializes itself as a "passwd" service with Linux-PAM and utilizes config-
       ured password modules to authenticate and then update a user’s password.

       A simple entry in the global Linux-PAM configuration file for this service would be:

        #
        # passwd service entry that does strength checking of
        # a proposed password before updating it.
        #
        passwd password requisite pam_cracklib.so retry=3
        passwd password required pam_unix.so use_authtok
        #

       Note, other module types are not required for this application to function correctly.

OPTIONS
       -k     The option -k, is used to indicate that the update should only be for expired authentication tokens (passwords); the user wishes to  keep  their  non-expired
              tokens as before.

       -l     This  option  is  used  to  lock the specified account and it is available to root only. The locking is performed by rendering the encrypted password into an
              invalid string (by prefixing the encrypted string with an !).

       --stdin
              This option is used to indicate that passwd should read the new password from standard input, which can be a pipe.

       -u     This is the reverse of the -l option - it will unlock the account password by removing the ! prefix. This option is available to root only. By default passwd
              will  refuse to create a passwordless account (it will not unlock an account that has only "!" as a password). The force option -f will override this protec-
              tion.

       -d     This is a quick way to delete a password for an account. It will set the named account passwordless. Available to root only.

       -e     This is a quick way to expire a password for an account. The user will be forced to change the password during the next login  attempt.   Available  to  root
              only.

       -n     This will set the minimum password lifetime, in days, if the user’s account supports password lifetimes.  Available to root only.

       -x     This will set the maximum password lifetime, in days, if the user’s account supports password lifetimes.  Available to root only.

       -w     This  will  set  the  number of days in advance the user will begin receiving warnings that her password will expire, if the user’s account supports password
              lifetimes.  Available to root only.

       -i     This will set the number of days which will pass before an expired password for this account will be taken to mean that the account is inactive and should be
              disabled, if the user’s account supports password lifetimes.  Available to root only.

       -S     This will output a short information about the status of the password for a given account. Available to root user only.

Remember the following two principles
       Protect your password.
              Don’t  write  down  your  password  - memorize it.  In particular, don’t write it down and leave it anywhere, and don’t place it in an unencrypted file!  Use
              unrelated passwords for systems controlled by different organizations.  Don’t give or share your password, in particular to someone claiming to be from  com-
              puter  support  or  a  vendor.  Don’t let anyone watch you enter your password.  Don’t enter your password to a computer you don’t trust or if things Use the
              password for a limited time and change it periodically.

       Choose a hard-to-guess password.
              passwd through the calls to the pam_cracklib PAM module will try to prevent you from choosing a really bad password, but  it  isn’t  foolproof;  create  your
              password  wisely.   Don’t use something you’d find in a dictionary (in any language or jargon).  Don’t use a name (including that of a spouse, parent, child,
              pet, fantasy character, famous person, and location) or any variation of your personal or account name.  Don’t use accessible information about you (such  as
              your phone number, license plate, or social security number) or your environment.  Don’t use a birthday or a simple pattern (such as backwards, followed by a
              digit, or preceded by a digit. Instead, use a mixture of upper and lower case letters, as well as digits or punctuation.  When choosing a new password,  make
              sure  it’s  unrelated  to any previous password. Use long passwords (say at least 8 characters long).  You might use a word pair with punctuation inserted, a
              passphrase (an understandable sequence of words), or the first letter of each word in a passphrase.

       These principles are partially enforced by the system, but only partly so.  Vigilence on your part will make the system much more secure.
```

### gpasswd 修改组密码

```
NAME
       gpasswd - administer /etc/group and /etc/gshadow

SYNOPSIS
       gpasswd [option] group

DESCRIPTION
       The gpasswd command is used to administer /etc/group, and /etc/gshadow. Every group can have administrators, members and a password.

       System administrators can use the -A option to define group administrator(s) and the -M option to define members. They have all rights of group administrators and
       members.

       gpasswd called by a group administrator with a group name only prompts for the new password of the group.

       If a password is set the members can still use newgrp(1) without a password, and non-members must supply the password.

   Notes about group passwords
       Group passwords are an inherent security problem since more than one person is permitted to know the password. However, groups are a useful tool for permitting
       co-operation between different users.

OPTIONS
       Except for the -A and -M options, the options cannot be combined.

       The options which apply to the gpasswd command are:

       -a, --add user
           Add the user to the named group.

       -d, --delete user
           Remove the user from the named group.

       -h, --help
           Display help message and exit.

       -Q, --root CHROOT_DIR
           Apply changes in the CHROOT_DIR directory and use the configuration files from the CHROOT_DIR directory.

       -r, --remove-password
           Remove the password from the named group. The group password will be empty. Only group members will be allowed to use newgrp to join the named group.

       -R, --restrict
           Restrict the access to the named group. The group password is set to "!". Only group members with a password will be allowed to use newgrp to join the named
           group.

       -A, --administrators user,...
           Set the list of administrative users.

       -M, --members user,...
           Set the list of group members.
```


### newgrp

```
NAME
       newgrp - log in to a new group

SYNOPSIS
       newgrp [-] [group]

DESCRIPTION
       The newgrp command is used to change the current group ID during a login session. If the optional - flag is given, the user´s environment will be reinitialized as
       though the user had logged in, otherwise the current environment, including current working directory, remains unchanged.

       newgrp changes the current real group ID to the named group, or to the default group listed in /etc/passwd if no group name is given.  newgrp also tries to add the
       group to the user groupset. If not root, the user will be prompted for a password if she does not have a password (in /etc/shadow if this user has an entry in the
       shadowed password file, or in /etc/passwd otherwise) and the group does, or if the user is not listed as a member and the group has a password. The user will be
       denied access if the group password is empty and the user is not listed as a member.

       If there is an entry for this group in /etc/gshadow, then the list of members and the password of this group will be taken from this file, otherwise, the entry in
       /etc/group is considered.

```

### su

```
NAME
       su - run a shell with substitute user and group IDs

SYNOPSIS
       su [OPTION]... [-] [USER [ARG]...]

DESCRIPTION
       Change the effective user id and group id to that of USER.

       -, -l, --login
              make the shell a login shell, clears all envvars except for TERM, initializes HOME, SHELL, USER, LOGNAME and PATH

       -c, --command=COMMAND
              pass a single COMMAND to the shell with -c

       --session-command=COMMAND
              pass a single COMMAND to the shell with -c and do not create a new session

       -f, --fast
              pass -f to the shell (for csh or tcsh)

       -m, --preserve-environment
              do not reset HOME, SHELL, USER, LOGNAME environment variables

       -p     same as -m

       -s, --shell=SHELL
              run SHELL if /etc/shells allows it

       --help display this help and exit

       --version
              output version information and exit

       A mere - implies -l.   If USER not given, assume root.
```

### 禁止普通用户登录

```
# touch /etc/nologin
```

这样就可以禁止除了 root 用户以外的用户登录

## user 和 group 进阶命令

### 锁定用户

```
# passwd -l username
```

* passwd -l 和 usermod -L 的区别

  passwd 在加密后密码字符串前加了两个!， 而 usermod 只加一个!，但可以都执行一次来互相解锁。usermod -U 执行一次就可以解锁 passwd -l 锁定的账户。

### 主要组和附属组


```
# gpasswd -a cls boss
Adding user cls to group boss
```

boss 将作为 cls 的附属组

```
$ newgrp boss #切换到 boss 用户组

# gpasswd -d cls boss
```

~~若附属组设置了密码，命令 newgrp group 需要输入附属组密码。(都是这个组的人了就不需要密码了)~~
经测试使用 ```newgrp group``` 切换到用户不属于的用户组(既不是主要组也不是附属组)才需要密码

### 切换到其他账户

su(substitute user)

su username


### 其他命令

* whoami

* id username

* groups username

* chfn username

* finger username
