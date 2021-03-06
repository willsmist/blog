---
title: JSON-java - 在 Java 中处理 JSON
date: 2016-10-12 14:40:49
tags:
- JSON
- Java
categories:
- Technique
- JSON
---

JSON 全称 JavaScript Object Notation ,是一种与开发语言无关的、轻量级的数据格式。JSON 最早来源于 JavaScript ，既易于人的阅读和编写，又易于程序的解析与生产，随着 JSON 使用越来越广泛，几乎每种开发语言都有处理 JSON 的 API 。

<!--more-->

---

# 标准 JSON 数据表示

* 数据结构
    * Object
    * Array
* 基本类型
    * string
    * number
    * true & false
    * null

## 数据结构-Object

使用花括号{}包含的键值对结构， Key 必须是 string 类型,Value 为任意基本类型或数据结构。

### 数据结构-Array

使用中括号[]包围,并使用逗号,来分割元素

一个简单的 JSON 样例

```JSON
{
  "name" : "Tom",
  "age" : 20,
  "school" : "Harvard",
  "studying" : true,
  "major" : [
    "CS",
    "Math"
  ],
  "address" : {
    "city" : "Boston"
    "st." : "somestreet"
  },
  "position" : "null"
}
```

# 使用 JSON-java 库处理 JSON

在包 org.json 中，包含了一个 JSONString 接口和JSONObject、JSONArray等几个常用的类,具体使用可参考 JSON 的文档。

## 生成 JSON

下面代码简单演示了生成 JSON 的三种方式,包括从 Map 和 JavaBean 中生成。

```java
public static void generateJSONObject(){
		JSONObject jsonObject = new JSONObject();
		Object aNull = null;
		jsonObject.put("name", "Jackson");
		jsonObject.put("gender", "1");
		jsonObject.put("age", 21);
		jsonObject.put("birthday", "1995-1-1");
		jsonObject.put("school", "Harvard");
		jsonObject.put("major", new String[]{"Math", "CS", "History"});
		jsonObject.put("Studying", true);
		jsonObject.put("position", aNull);
		jsonObject.put("comment", "This is a commont");

		String jsonStr = jsonObject.toString();
		System.out.println(jsonStr);
	}

	public static void jsonFromMap(){
		Map<String, Object> user = new HashMap<String, Object>();
		Object anull = null;
		user.put("name", "Jackson");
		user.put("gender", "1");
		user.put("age", 25);
		user.put("birthday", "1990-11-20");
		user.put("school", "Harvard");
		user.put("major", new String[]{"Math", "CS", "History"});
		user.put("Studying", true);
		user.put("position", anull);
		user.put("comment", "This is a commont");

		String jsonStr = new JSONObject(user).toString();
		System.out.println(jsonStr);
	}

	public static void jsonFromJavaBean(){
		User user = new User();
		user.setId(1001);
		user.setName("Tom");
		user.setGender("1");
		user.setAge(25);
		try {
			user.setBirthday(new SimpleDateFormat("yyyy-mm-dd").parse("1990-10-29"));
		} catch (ParseException e) {
			e.printStackTrace();
		}
		user.setSchool("Harvard");
		user.setMajor(new String[]{"Marh", "CS", "History"});
		user.setStudying(true);
		user.setPosition(null);
		user.setComment("This is a comment");

		String jsonStr = new JSONObject(user).toString();
		System.out.println(jsonStr);
	}
```

## 解析 JSON

获取 JSON 数据的途径可以是一个文件，也可以是网络，但解析的过程是一样的。

代码示例

```JSON
包含 JSON 数据的文件为 content.json:
{
  "ID": 1001,
  "NAME": "Tom",
  "gender": "1",
  "age": 25,
  "birthday": "Jan 29, 1990 12:10:00 AM",
  "major": [
    "Marh",
    "CS",
    "History"
  ],
  "Studying": true,
  "comment": "This is a comment"
}
```

```java
public static void main(String[] args) throws IOException {
		File file = new File("content,json");
		String jsonStr = FileUtils.readFileToString(file, Charsets.toCharset("utf-8"));
		JSONObject json = new JSONObject(jsonStr);
		if(!json.isNull("id")){
			System.out.println(json.getInt("id"));
		}
		if(!json.isNull("major")){
			JSONArray arr = json.getJSONArray("major");
			for(int i = 0; i < arr.length(); i++){
				System.out.println("major-" + (i+1) + ":" + arr.getString(i));
			}
		}
	}
```

JSONObject 可以将一个 JavaBean 转换为 JSON 格式，但无法使用 JSONObject 将 JSON 格式转换为一个 JavaBean。只能通过访问其属性，来获得相应的值。此时，可以考虑使用 Google 的 Gson 库来实现这一目的。
