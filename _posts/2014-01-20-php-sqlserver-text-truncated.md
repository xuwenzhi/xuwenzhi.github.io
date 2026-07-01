---
layout: post
title: "PHP取SqlServer的text字段被截断"
tags: php sqlserver
---

微软真的霸气侧露，自家的Sql Server2005中text字段，有些深度啊。

当使用PHP链接Sql Server时，如果正好有一字段为text类型时，取得的字符串会被截断为4096个字节，解决这个问题只需要修改php.ini中的mssql.textsize即可，数量调大一点即可：

```
mssql.textsize = 20000;

```

PHP取SqlServer的text字段被截断
