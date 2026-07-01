---
layout: post
title: "PHP与文件压缩(Zlib)"
tags: php zlib
---

    作为服务端开发人员，我们有可能会对一个文件或者一个文件夹进行压缩，因为需求总是不确定的嘛~PHP为我们提供了Zlib库，能够让我们轻松实现压缩的功能。

**主要函数**

```
$fp = gzopen('文件路径', '打开模式');
gzwrite($fp, '写入内容value');
gzclose($fp);

```

**实际上这个跟普通的文件处理函数是一样的，例如fopen(),fwrite(),fclose(),只不过这里的gz类函数，是直接将文本内容写入压缩文件。**

```
<?php
//对数据库文件进行压缩备份
$db_name = 'books'; //对哪个数据库备份
$dir = "back_up/$db_name/"; //将备份后的数据库文件存放位置
if(!is_dir($dir)){
 if(!@mkdir($dir, 0777)){ //如果存放的文件夹不存在，就创建，并且权限要最高
  die('备份文件夹创建不了');
 }
}//如果不存在备份文件夹
$time = time(); //定义一个函数变量，用于存放时间戳，作为文件名
$conn = mysql_connect('localhost' , 'root', '') or die('数据库连接失败');
mysql_select_db('books', $conn) or die('选择数据库失败');
mysql_query("set names 'utf8'");//设定编码方式，这一点是有必要的，因为之前没有这一句的时候，压缩出来的文件文字是乱码
$q = "show tables";//获取该数据库中的表
$r = mysql_query($q);
if(mysql_num_rows($r) > 0){
 echo "备份 $db_name 数据库<br/>";
 while(list($table) = mysql_fetch_array($r)){
  $q2 = "Select * from $table";//查询表中数据
  $r2 = mysql_query($q2);
  if(mysql_num_rows($r2) > 0){
   //通过压缩的方式创建并且打开需要压缩的某个表的压缩文件
   if($fp = gzopen("$dir/{$table}_{$time}.sql.zip", 'w9')){
    while($row = mysql_fetch_array($r2)){
     //通过foreach遍历表中数据
     foreach($row as $value){
      gzwrite($fp, "'$value', ");//通过gzwrite()来将表中数据写入压缩文件中
     }
     gzwrite($fp, '\n');//并且在遍历一行表中数据后，添加一个换行
    }
    gzclose($fp);
    echo "{$table}已经备份完毕<br/>";
   }else{
    echo "无法创建压缩文件";
   }
  }
 }
}
?>

```

** **
**在该代码中，可以将back_up文件夹放在Web文件夹之外，可提高安全性。**
**该技术在数据量小的时候效果不是特别明显，但是当数据量较大的时候就会有非常明显的压缩效果。**
PHP与文件压缩(Zlib)
