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

| Difference | InnoDB | MyISAM |
| :------- | :--------: | :-------: |
| Lock | Row-level lock | Table-level lock |
| Full-text index support | No (but can be combined with Sphinx) | Yes |
| Automatic crash recovery support | Yes | No |
| Delayed index flushing to disk | No | Yes (requires DELAY_KEY_WRITE enabled) |
| Main difference | In InnoDB, clustered index "is" the table, so unlike MyISAM, there's no need for separate row storage. Unlike MyISAM, InnoDB's secondary index leaf nodes store the primary key value, not row pointers. | Stores data on disk in insertion order. Because of the sequential storage, there's a row number (starting from 0) when storing, making index creation easy |


## Other Principles

- If you don't create a primary key for a table, InnoDB will create a custom primary key due to clustered indexing. But the effect of this result is really not as good as adding a primary key field yourself. This not only ensures performance but also ensures the data volume of the index! Moreover, this ensures sequential data storage and allows continued insertion into new pages when a page is full, which can prevent page splits and data fragmentation.

- When using index scans for sorting, a key point to ensure performance is that the ORDER BY should be consistent with the index column order. When you need to ORDER BY two index columns together, the same logic applies. If one of the index columns has a different order, you can store the reverse order of that column!
