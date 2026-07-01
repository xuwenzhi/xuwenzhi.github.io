---
layout: post
title: "Web Sql Database 初探"
tags: websql html5
---

由于项目需求，需要做一款基于PhoneGap和HTML5配合的手机客户端，也考虑到了许多问题，其中一个主要的问题是希望能够在客户端能够加入数据缓存，查了一下随着HTML5的逐步完善，现在有四种方式来存储数据， localStorage，SessionLocalstorage，IndexDB 和 WebSql database ，之前经常使用的是localStorage，但是觉得这种存储方式跟关系型数据库的操作方便性上面差远了，所以来研究了一下Web Sql Database(一下简称WSDB)。

**基本了解一下WSDB**

WSDB API 实际上并不包含在 HTML5 规范之中。它是一个独立的规范，它引入了一套使用 SQL 操作客户端数据库的 API。

**兼容性**

浏览器:最新版本的 Chrome，Safari 和 Opera 浏览器都支持 Web SQL Database。

手机平台: 仅有Android IOS BB 支持。

**具体使用方法**

**①:创建操作数据库的对象**

var db = null;

try {

if (!db) {

db = openDatabase(‘microcloud’, ‘1.0’, ‘微云’, 100000000);  //参数1 数据库名称 参数2 数据库版本 参数3:数据库描述 参数4 建立的数据库的最大容量

//创建表

db.transaction(function(tx){                   tx.executeSql(‘create table if not exists mainboards(id integer NOT NULL PRIMARY KEY AUTOINCREMENT,name text,title text)’,[]);//创建mainboards表

});

}

} catch (e) {

alert(“操作失败，建议您重启软件” + e);

db = null;

}

执行之后在chrome浏览器审查元素会看到

**②:向数据库中增加数据**

db.transaction(function(tx){

tx.executeSql(‘insert into mainboards(name, title) values(?,?)’,[‘name’,‘title’],function(tx,rs){

alert(‘保存成功’);

},function(tx,error){

alert(error.source + “::” + error.message);}

);

});

**③:查找数据库中的数据**

db.transaction(function(tx){

tx.executeSql(sql_str, [] ,function(tx, rs){

var len = rs.rows.length;//mainboards中的数据条数

var HTML = “”;

for(var i = 0; i < len; i++){

alert(rs.rows.item(i).title);

HTML += rs.rows.item(i).title;

}

document.getElementById(‘mainboards’).innerHTML = HTML;

return rs;//将SQL语句拿到的内容返回  我是希望能够返回，但是在Sql的这个函数中返回是返回不回去的，然后我想把它加在回调函数中返回，不过也是行不通的

});

});

**四:删除数据库中的某个表**

****

db.transaction(function(tx){
    tx.executeSql(‘drop table ‘+tb_name, [] ,function(tx, rs){
        alert(‘成功删除表’+tb_name);
    });
});

 

**基本的对数据库的操作类似于关系型数据库，只不过WSDB是个小型的关系型数据库，操作方法基本都是同样的。**

**问题总结:**

①:很希望能够再将WSDB中的这些CURD(增删查改)都能封装起来，但是实际发现，真的是不喜欢JS的这种回调，好乱的感觉，比如当我想把对某个表的语句封装成一个函数的时候，无法通过return 返回，唯一的办法只能像处理C一样类似的写过程式代码，由于没有学过JS，不知道是否可以通过类来封装。

**最新发现**

当我在WSDB中建立多个数据表的时候，发现它自动创建了个表，叫做sqllite_sequence 的数据表，这里面存放的东西很简单，就是我自己创建的表中的记录的条数。

W3C参考网址:[http://dev.w3.org/html5/webdatabase/](http://dev.w3.org/html5/webdatabase/)

Web Sql Database 初探
