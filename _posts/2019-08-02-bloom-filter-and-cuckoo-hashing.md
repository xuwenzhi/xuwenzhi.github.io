---
layout: post
title: Bloom Filter and Cuckoo Hashing.
tags: design
---

# Bloom Filter

[wiki:布隆过滤器](https://zh.wikipedia.org/wiki/%E5%B8%83%E9%9A%86%E8%BF%87%E6%BB%A4%E5%99%A8)

## 布隆过滤器的原理

当一个元素被加入集合时，通过 **K个散列函数** 将这个元素映射成一个位数组中的K个点，把它们置为1。检索时，我们只要看看这些点是不是都是1就（大约）知道集合中有没有它了：如果这些点有任何一个0，则被检元素一定不在；如果都是1，则被检元素很可能在。这就是布隆过滤器的基本思想。

以下为布隆过滤器的大致流程。

```c
// 位数组的长度 m 需要推导出来
vector<bit> bit_array(length);
string = "xuwenzhi";

// 计算K个hash函数对应的 index
index1 = hash_func1(string);
index2 = hash_func2(string);
index3 = hash_func3(string);
...// 具体hash函数的个数要根据实际的数据量推导

// add
bit_array[index1] = 1;
bit_array[index2] = 1;
bit_array[index3] = 1;

// check
return bit_array[index1] && bit_array[index2] && bit_array[index3] ...
```

## process

1. add geeks
![](http://cdncontribute.geeksforgeeks.org/wp-content/uploads/geeks1-300x107.png)

2. add nerd

![](http://cdncontribute.geeksforgeeks.org/wp-content/uploads/nerd-300x114.png)

3. check cat

![](http://cdncontribute.geeksforgeeks.org/wp-content/uploads/cat-300x109.png)

由上三张图可知，布隆过滤器是一个概率上的问题，会有一定的 **Probability of False positivity**，而这个误判率究竟多少呢？取决于下面这个公式:

![](https://www.geeksforgeeks.org/wp-content/ql-cache/quicklatex.com-78e77c34323cfb8afff2a80c0e91b26d_l3.svg)

假如我希望有1%的**Probability of False positivity**

- 继而可以反推bit_array的长度

![](https://www.geeksforgeeks.org/wp-content/ql-cache/quicklatex.com-8a21b35f5419f7968aafd408590b37bd_l3.svg)

- 继而也可以知道需要几个hash函数

![](https://www.geeksforgeeks.org/wp-content/ql-cache/quicklatex.com-88930c4f1e1c21cd0ce0569adbddde16_l3.svg)

## 优点

1. 节省空间，仅由bit_array的长度决定
2. 节省时间，得益于数组的随机访问，时间复杂度取决于K个hash函数的复杂度 O(K)
3. 容易实施

## 缺点

1. 存在误判率，但是具体比率是可以控制的
2. 不能删除key，也就是不能针对某个key将bit_array对应的index的value置为0.


## 应用

1. Google判断你是否浏览过此URL
2. 爬虫抓取过滤URL
3. 注册判断是否注册过此名称

## refer

[Bloom Filters – Introduction and Python Implementation](https://www.geeksforgeeks.org/bloom-filters-introduction-and-python-implementation/)

[BloomFilter relative Paper](https://antognini.ch/papers/BloomFilters20080620.pdf)

[BloomFilter开源实现(c++)](https://github.com/liheyuan/BloomFilter-For-KeSeek)

# Cuckoo Hashing

上面说的是BloomFilter无法存在误判，而且无法删除key。在这个背景下，出现了布谷鸟Hash，而布谷鸟Hash同样还有解决Hash冲突的作用。

## 基本原理

使用2个HashTable（T1,T2），两个Hash函数(F1->T1, F2->T2)

插入操作如下：

1. 对key值hash，生成两个hash key值，hashk1和 hashk2, 如果对应的两个位置上有一个为空，那么直接把key插入即可。

2. 否则，任选一个位置，把key值插入，把已经在那个位置的origin key值踢出来。

3. 被踢出来的origin key值，需要重新插入。循环直到没有key被踢出为止。

Note:当然很可能第3步中的循环过程可能会存在死循环，而布谷鸟Hash一般都会有个 **踢出上限** 所以如果达到踢出上限，那么就需要进行 **rehash**。

> 详细步骤，查看[Cuckoo Hashing – Worst case O(1) Lookup!](https://www.geeksforgeeks.org/cuckoo-hashing/)

## Time Complexity

Insertion : 最好的情况是O(1)，但也取决于是负载因子，当达到一定负载因子阈值的时候，可能需要进行rehash，所以最坏情况取决于Table大小。

Deletion : O(1)

## refer

[Cuckoo Hashing – Worst case O(1) Lookup!](https://www.geeksforgeeks.org/cuckoo-hashing/)

[BloomFilter 与 CuckooFilter](https://www.cnblogs.com/chenny7/p/4074250.html)

[Stanford Hashtable Analysis](https://web.stanford.edu/class/archive/cs/cs166/cs166.1146/lectures/13/Small13.pdf)
