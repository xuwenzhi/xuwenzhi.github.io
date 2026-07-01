---
layout: post
title: "valgrind入门"
tags: valgrind c
---

**valgrind是什么？**

答：valgrind是一个检查C代码是否存在内存泄露的工具，当我们通过malloc()创建动态空间的时候，如果没有及时的free掉，那么这块动态空间别人也会用不了，长此以往，内存会越来越小，导致计算机越来越慢。

**valgrind原理？**

答：valgrind会拦截你对malloc()和free()的调用，从而检查是否存在内存泄露。

**那么如何使用valgrind？**

答：首先需要安装valgrind。

**在Linux下安装valgrind？**

1. 到www.valgrind.org下载最新版valgrind-3.2.3.tar.bz2

2. 解压安装包：tar –jxvf valgrind-3.2.3.tar.bz2

3. 解压后生成目录valgrind-3.2.3

4. cd valgrind-3.2.3

5. 运行./autogen.sh设置环境（需要标准的autoconf工具）（可选）

6. ./configure;配置Valgrind，生成MakeFile文件，具体参数信息详见INSTALL文件。一般只需要设置–prefix=/where/you/want/it/installed

7. Make；编译Valgrind

8. make install；安装Valgrind

**如何使用valgrind?**

首先新建一个valgrind.c文件，例如

```
#include<stdio.h>
#include<stdlib.h>
int main(int argc, const char * argv[]){
    int *p = malloc(4);
    *p = 6;
    //free(p);
    return 0;
}

```

编译，此时使用了-g参数，告诉编译器要记录编译代码的行号

```
gcc -g valgrind.c -o valgrind

```

valgrind登场

```
valgrind --leak-check=full ./valgrind

```

**valgrind结果分析**

从图中可以看到，我们lost了4个字节，因为我们使用malloc()创建了4字节的空间，然而并没有free掉，所以valgrind分析出了这个问题。

**好了，就酱**

你还可以试试把free加上，再通过valgrind分析下看看结果如何。这篇仅仅是valgrind的简短入门，valgrind还有很多高级特性，值得我们去探索。

valgrind入门
