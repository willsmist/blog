---
title: JDBC 几点注意
date: 2016-11-26 20:19:14
tags:
- Java
- JDBC
categories:
- Technique
- Java
---

在 JDBC 中发现的一些本人未知或者由于水平有限而无法解释的表现
<!--more-->

---

* 数据库连接参数后的空格

JDBC 连接 Oracle 数据库时，数据库参数配置文件 .properties 中定义驱动的字符串后面不能加空格，而其他如 url,username,password 后面加空格却不影响访问数据库。下面是 Eclipse 中 .properties 数据库连接数据示例:

```text
#oracle
driver=oracle.jdbc.OracleDriver
url=jdbc:oracle:thin:@localhost:1521:xe
username=test
password=123456
```

username 后面跟5个空格，程序中得到的 username 所保存的字符串的长度显示是9，也就是包含了空格的长度。可以判断是 Oracle 数据库对其进行了处理。可能本来就是数据库会对登录参数前后的空白字符进行删除处理，只是之前不知道而已。
