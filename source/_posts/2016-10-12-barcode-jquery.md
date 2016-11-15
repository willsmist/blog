---
title: jquery.qrcode
date: 2016-10-12 14:53:39
tags:
- Barcode
- QRCode
- jQuery
- 条形码
- 二维码
categories:
- Technique
- Barcode
---
jquery.qrcode.js 是一个用于生成 QRCode 的 jQuery 插件，可以轻松实现在网页中添加 QRCode，建立在 jQuery 基础之上，不需要其他的依赖，小巧方便。

<!--more-->

---

使用该插件需要先引入 jQuery 的文件。
```
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="<%=request.getContextPath() %>/js/jquery.qrcode.min.js"></script>
```

生成二维码的代码非常简洁：

```
<div id="qrcode"></div>

<script type="text/javascript">
	$('#qrcode').qrcode("http://www.yglwy.com");
</script>
```

![](/images/barcode/jquery-qrcode.png)

以上代码会在指定的 div 中生成相应的二维码。需要注意的是 **生成二维码的 JavaScript 代码要放在 div 的后面**。
