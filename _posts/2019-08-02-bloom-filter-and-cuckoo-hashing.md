---
layout: post
title: Bloom Filter and Cuckoo Hashing.
tags: design
---

# Bloom Filter

<!-- more -->

## How Bloom Filters Work

When an element is added to a set, it is mapped to K points in a bit array through **K hash functions**, and those points are set to 1. When checking, we just need to see if all these points are 1 to (approximately) know if the element is in the set: if any of these points is 0, the checked element is definitely not in the set; if all are 1, the checked element is probably in the set. This is the basic idea of the Bloom filter.

The following is the general flow of a Bloom filter.

```c
// The length m of the bit array needs to be derived
vector<bit> bit_array(length);
string = "xuwenzhi";

// Calculate the index corresponding to K hash functions
index1 = hash_func1(string);
index2 = hash_func2(string);
index3 = hash_func3(string);
... // The specific number of hash functions should be derived based on actual data volume

// add
bit_array[index1] = 1;
bit_array[index2] = 1;
bit_array[index3] = 1;

// check
return bit_array[index1] && bit_array[index2] && bit_array[index3] ...
```

## Process

1. add geeks
![](http://cdncontribute.geeksforgeeks.org/wp-content/uploads/geeks1-300x107.png)

2. add nerd

![](http://cdncontribute.geeksforgeeks.org/wp-content/uploads/nerd-300x114.png)

3. check cat

![](http://cdncontribute.geeksforgeeks.org/wp-content/uploads/cat-300x109.png)

From the three diagrams above, we can see that the Bloom filter is a probabilistic matter with a certain **Probability of False Positivity**. How much is this false positive rate? It depends on the following formula:

![](https://www.geeksforgeeks.org/wp-content/ql-cache/quicklatex.com-78e77c34323cfb8afff2a80c0e91b26d_l3.svg)

Suppose we want a 1% **Probability of False Positivity**

- We can then derive the length of bit_array

![](https://www.geeksforgeeks.org/wp-content/ql-cache/quicklatex.com-8a21b35f5419f7968aafd408590b37bd_l3.svg)

- We can also know how many hash functions are needed

![](https://www.geeksforgeeks.org/wp-content/ql-cache/quicklatex.com-88930c4f1e1c21cd0ce0569adbddde16_l3.svg)

## Advantages

1. Saves space, determined only by the length of bit_array
2. Saves time, thanks to random access of arrays, time complexity depends on the complexity of K hash functions O(K)
3. Easy to implement

## Disadvantages

1. There is a false positive rate, but the specific rate can be controlled
2. Cannot delete keys, meaning you cannot set the value of the corresponding index in bit_array to 0 for a specific key


## Applications

1. Google determining if you've visited a URL
2. Web crawler URL filtering
3. Registration checking if a username is already taken

## Reference

[wiki: Bloom Filter](https://zh.wikipedia.org/wiki/%E5%B8%83%E9%9A%86%E8%BF%87%E6%BB%A4%E5%99%A8)

[Bloom Filters – Introduction and Python Implementation](https://www.geeksforgeeks.org/bloom-filters-introduction-and-python-implementation/)

[BloomFilter relative Paper](https://antognini.ch/papers/BloomFilters20080620.pdf)

[BloomFilter Open Source Implementation (C++)](https://github.com/liheyuan/BloomFilter-For-KeSeek)

# Cuckoo Hashing

As mentioned above, BloomFilter has false positives and cannot delete keys. In this context, Cuckoo Hash emerged, and Cuckoo Hash also has the function of resolving hash collisions.

## Basic Principle

Uses 2 HashTables (T1, T2), two Hash functions (F1->T1, F2->T2)

Insertion operation as follows:

1. Hash the key value, generate two hash key values, hashk1 and hashk2. If one of the two corresponding positions is empty, directly insert the key.

2. Otherwise, choose any position, insert the key, and kick out the original key that was already in that position.

3. The kicked out original key needs to be reinserted. Loop until no key is kicked out.

Note: Of course, the loop in step 3 might result in an infinite loop. Cuckoo Hash generally has a **kick-out limit**, so if the kick-out limit is reached, a **rehash** is needed.

> For detailed steps, see [Cuckoo Hashing – Worst case O(1) Lookup!](https://www.geeksforgeeks.org/cuckoo-hashing/)

## Time Complexity

Insertion: Best case is O(1), but also depends on the load factor. When a certain load factor threshold is reached, rehash may be needed, so the worst case depends on the table size.

Deletion: O(1)

## Reference

[Cuckoo Hashing – Worst case O(1) Lookup!](https://www.geeksforgeeks.org/cuckoo-hashing/)

[BloomFilter and CuckooFilter](https://www.cnblogs.com/chenny7/p/4074250.html)

[Stanford Hashtable Analysis](https://web.stanford.edu/class/archive/cs/cs166/cs166.1146/lectures/13/Small13.pdf)
