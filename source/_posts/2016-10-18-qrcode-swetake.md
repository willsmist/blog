---
title: Swetake Qrcode - 基于 Java 的 QR Code 编码类库
date: 2016-10-18 14:57:44
tags:
- Barcode
- QR Code
- Java
- 条形码
- 二维码
categories:
- Technique
- Barcode
- QR Code
---

[QRcode - swetake.com](http://www.swetake.com/qrcode/index-e.html) 提供了一个基于 Java 的 QR Code 编码类库，可在 Java 项目中使用该类库生成和解析二维码。下载页面是日文的，现将下载地址放在[这里](http://www.swetake.com/programs/qrcode_java0.50beta10.tar.gz)。

<!--more-->

---

# 生成 QR Code

通过 Qrcode 类定义的方法实现。

```java
public class QrcodeGen {

	public static void main(String[] args) {

		int width= 67 + 12 * ( 7 -1 );
		int height = 67 + 12 * ( 7 -1 );
		BufferedImage image = new BufferedImage(width,height,BufferedImage.TYPE_INT_RGB);
		Graphics2D gs = image.createGraphics();
		gs.setBackground(Color.white);
		gs.setColor(Color.BLACK);
		gs.clearRect(0, 0, width, height);

		Qrcode x = new Qrcode();
		x.setQrcodeErrorCorrect('M');
		x.setQrcodeEncodeMode('B');//N代表数字，A代表a-z,B代表其他字符
		x.setQrcodeVersion(7);

		String qrData = "https://guo-long.github.io/";

		int pixoff = 2;//偏移量

		byte[] d = qrData.getBytes();
		if(d.length>0 && d.length<120){
			boolean[][] s = x.calQrcode(d);

			for(int i = 0; i < s.length; i++){
				for(int j = 0; j < s.length; j++){
					if(s[j][i]){
						gs.fillRect(j*3 + pixoff, i*3+pixoff, 3, 3);
					}
				}
			}
		}

		gs.dispose();
		image.flush();
		try {
			ImageIO.write(image, "png", new File("barcode/qrcode.png"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
```

![](/images/barcode/qrcode.png)

# 解析 QR Code

```java
public class QrcodeReader {

	public static void main(String[] args) {
		File file = new File("barcode/qrcode.png");
		BufferedImage image = null;
		try {
			 image = ImageIO.read(file);
			 QRCodeDecoder decoder = new QRCodeDecoder();
			 String result = new String(decoder.decode(new QRCodeImageImpl(image)),"utf-8");
			 System.out.println(result);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}

public class QRCodeImageImpl implements QRCodeImage{

	private BufferedImage image;

	public QRCodeImageImpl(BufferedImage image){
		this.image = image;
	}

	@Override
	public int getHeight() {
		return image.getHeight();
	}

	@Override
	public int getPixel(int arg0, int arg1) {
		return image.getRGB(arg0, arg1);
	}

	@Override
	public int getWidth() {
		return image.getWidth();
	}

}

```
