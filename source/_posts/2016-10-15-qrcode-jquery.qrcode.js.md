---
title: jquery.qrcode.js - 用于生成 QR Code 的 jQuery 插件
date: 2016-10-15 14:53:39
tags:
- Barcode
- QR Code
- jQuery
- 条形码
- 二维码
categories:
- Technique
- Barcode
- QR Code
---

[jquery.qrcode.js](http://jeromeetienne.github.io/jquery-qrcode/) 是一个用于生成 QRCode 的 jQuery 插件，可以轻松实现在网页中添加 QRCode，不需要其他的依赖，简单易用。类似的 JavaScript 库还有 [QRCode.js](https://github.com/davidshimjs/qrcodejs)等。

<!--more-->

---

使用该插件需要先引入 jQuery 的文件。

```html
<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/jquery.qrcode.min.js"></script>
```

生成二维码的代码非常简洁：

```html
<div id="qrcode"></div>
<script type="text/javascript">
	$('#qrcode').qrcode({
		width: 64,
		height: 64,
		text: "https://guo-long.github.io/"
	});
</script>
```

![](/images/barcode/jquery-qrcode.png)

需要注意的是在本例中生成二维码的 JavaScript 代码要放在 `div` 的后面。