---
layout: post
title: The Difference of InnoDB and MyISAM
tags: mysql
---

# The Difference of InnoDB and MyISAM

<!-- more -->

```

CREATE TABLE layout_test(
	col1 int not null,
	col2 int not null,
	primary key(col1),
	key(col2)
);

```

|    区别    | InnoDB |MyISAM|
| ---------- | --- |--|
| 锁 |  行级锁 |表级锁|
| 是否支持全文索引       |  否(但可以配合sphinx) |是|
|是否支持自动崩溃恢复|是|否|
|是否支持延迟索引落盘|否|是(需开启DELAY_KEY_WRITE)|
| 主要不同点      |InnoDB中，聚簇索引"就是"表，所以不像MyISAM那样需要独立的行存储。与MyISAM不同的是，InnoDB的二级索引的叶子节点保存的不是行指针，而是主键值。  | 按照数据插入顺序存储在磁盘上，因为是按照顺序，所以在存储时存在一个行号(从0开始)，可以很容易创建索引 |


## 其他原则

- 如果没有为表建立主键，那么InnoDB会因为聚簇索引的缘故，自定义一个主键，但这种结果引发的效果真的不如自己加一个主键字段，不仅保证了性能，而且保证了索引的数据量！而且这样保证了数据的顺序存储以及在当页被插满后可以继续插入新页，可以杜绝页分裂和数据碎片。

- 使用索引扫描来做排序时，如果需要保证性能，一个关键的点是，order by 与索引列的顺序保持一致。当需要对两个索引列一同进行order by时，也是一样的道理，如果其中有一个索引列顺序不同时，可以存储该字段的反顺序列！
