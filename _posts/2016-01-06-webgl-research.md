---
layout: post
title: "WebGL技术调研"
tags: webgl graphics
---

**What is WebGL?**

WebGL实际上是一个在浏览器中创建2/3D动画的库，使用了H5 <canvas>标签实现。既然实现了3D动画，也就是说它最根本的动作是操作DOM，也支持能操作DOM的编程语言，比如Javascript,PHP和Java等，并且如果是在Mac平台，内嵌Webkit的应用也支持Object-C。

**Why not canvas?**

<canvas>已经实现了基本的动画，也非常丰富，但是唯一的缺点是：不支持3D。如果需要3D还是需要WebGL。

**Prospect of WebGL?**

- API基于熟知的3D动画标准

- 跨平台跨浏览器

- 和HTML紧密融合，包括页面布局，交互使用了HTML标准事件Hanlder

- 浏览器环境3D动画硬件加速渲染

- 不需编译，不需链接

- 众多主流浏览器Google (Chrome), Opera (Opera), Mozilla (Firefox), and Apple (Safari) 是Khronos（WebGL官方组织）的财团

**Version?**

1.0 : 支持众多主流浏览器，并且相对成熟

2.0 ：要求硬件支持OpenGL ES 3.0，并且不完全向下兼容

检查浏览器对1.0和2.0的支持状况： [http://analyticalgraphicsinc.github.io/webglreport/?v=1](http://analyticalgraphicsinc.github.io/webglreport/?v=1)

**Operation Principle of WebGL?**

- 3D   ->   2D  屏幕

- Model          模型转换(以参照物为基准)

- View            视图转换(类似于3视图)

- Projection   投影转换(近大远小)

WebGL中的矩阵模型均为4*4。

**How to learn WebGL?**

- GLSL（OpenGL Shading Language）, 被OpenGL和WebGL用来做着色语言，主要因为使用它可以跨浏览器跨平台，语法风格类似c语言。它在WebGL中主要控制物体的顶点位置以及物体各个面的颜色。（难度: 4.5颗星）

- WebGL本身的API，主要控制整个2/3D动画的流程。 (难度:4颗星)

- WebGL与GLSL的交互。 物体在运动中，WebGL需要和GLSL相互交换一些顶点位置的信息。(难点4颗星)

- Matrix计算，这一点倒没什么，只要理解一些第三方提供的矩阵计算API即可。(难度:3颗星)

Note:难度最高(5颗星)。

**Third party library**

webgl的第三方库主要包含 : 矩阵计算，矩阵运动，还有官方出品的对webgl本身封装的库。

官方提供：

webgl_utils.js //主要做了SetUp的工作，另外使用window.requestAnimFrame来做监听

[https://github.com/KhronosGroup/WebGL/blob/master/sdk/demos/common/webgl-utils.js](https://github.com/KhronosGroup/WebGL/blob/master/sdk/demos/common/webgl-utils.js)

J3DI.js      // 提供WebGL的初始化、加载着色器、正方体和球体模型的生成

[https://github.com/KhronosGroup/WebGL/blob/master/sdk%2Fdemos%2Fwebkit%2Fresources%2FJ3DI.js](https://github.com/KhronosGroup/WebGL/blob/master/sdk%2Fdemos%2Fwebkit%2Fresources%2FJ3DI.js)

J3DIMath.js  // 多矩阵的生成、计算和运动。

[https://github.com/KhronosGroup/WebGL/blob/master/sdk%2Fdemos%2Fwebkit%2Fresources%2FJ3DIMath.js](https://github.com/KhronosGroup/WebGL/blob/master/sdk%2Fdemos%2Fwebkit%2Fresources%2FJ3DIMath.js)

MDN(Mozilla Developer Network)推荐:

glMatrix  //并没有用这个，是一个致力于高性能矩阵和向量计算的库，github上Star 1559

[https://github.com/toji/gl-matrix](https://github.com/toji/gl-matrix)

Sylvester.js  //和上面这个功能差不多，性能稍差，但健壮性强

[sylvester官网](http://sylvester.jcoglan.com)

glUtils.js   //是上面这个Sylvester的补充

其他:

minMatrix.js   //一个日本人写的主要用于矩阵计算和矩阵运动的库，相对于官方库看起来清晰一些，虽然方法少一些，但是容易理解

[minMatrix官网](https://wgld.org/j/minMatrix.js)

综述：

官方的库较为成熟，且兼容性明显要高出一点，且对于矩阵和向量的计算，J3DIMath.js就完全可以胜任。且封装的很好，在此基础上再稍微封装一层即可，不建议入门学习。

火狐推荐的库学习成本稍高一些，且结构零散，不建议入门学习。

另外，minMartix.js学习成本稍微低一些，可以拿来做简单入门理解WebGL工作原理，且那位日本哥儿们还封装了许多方法，很棒！

So，库还是官方靠谱一点。

**Simple WebGL workflow**

- 获取canvas对象 ： canvas = document.getElementById(“glcanvas”);//get canvas obj

- 初始化WebGL渲染语境 : GL = canvas.getContext(“experimental-webgl”);

- WebGL基础配置

- Initialize the shader(vertexShader & fragmentShader …)

- 将shader attach到WebGL语境中

- 使用Js建立矩阵数组

- Initialize the Buffers (create -> bind -> bufferData)，设置具体的物体，每一帧相当于一个buffer，一个小画面需要创建一个小buffer，并且绑定到某个特定的容器中。

- MATRIX 建立矩阵模型

- DRAWING

- 定时更新canvas动画

**Disassembly workflow**

获取canvas对象

html

```
<canvas id="glcanvas" width="640" height="480" style="background-color:black;">
      Your browser doesn't appear to support the <canvas> element.
</canvas>

```

js

```
var canvas = document.getElementById('glcanvas');
try {
  gl = canvas.getContext('experimental-webgl');
} catch (e) {
  throw new Error('no WebGL found');
}

```

初始化WebGL语境

```
try {
  gl = canvas.getContext('experimental-webgl');
} catch (e) {
  throw new Error('no WebGL found');
}

```

WebGL基础配置

```
gl.clearColor(0.0, 0.0, 0.0, 1.0);  // Clear to black, fully opaque
gl.clearDepth(1.0);                 // Clear everything

```

Initialize the shader(vertexShader & fragmentShader …)

为什么要初始化shader,后面的vertexShader和fragmentShader什么意思？

答：vertexShader是模型各个顶点的着色器，没有订单也就没有模型。fragmentShader是模型各个小片段的颜色。另一方面为了能够兼容性以及移植性，我们需要定义vertexShader和fragmentShader。且还需要是这两种着色器的program。program就像一个小程序一样。

vertexShader和fragmentShader有什么区别？

答：vertexShader控制图形顶点的位置。fragmentShader控制图形中每一个像素的颜色。

WebGL的着色器说明？

答：由于一个动画是一个流水线工作，然而WebGL并没有提供那个可以控制整个流水线的功力，专业术语叫：固定渲染管线。控制流水线正常按顺序进行的操作还需要由程序员来自己完成，也就是程序员需要完善这个可编辑的渲染管线，GLSL也就出现了，其实GLSL是一种着色语言。

整个WebGL的难点之一，因为又得去学习一门语言了。

GLSL的基本语法：

http://blog.csdn.net/lufy_legend/article/details/38342919

怎么定义shader?

答：有两种方式。

js定义

```
var vertCode =
     'attribute vec2 coordinates;' +
     'void main(void) {' +
     '  gl_Position = vec4(coordinates, 0.0, 1.0);' +
     '}';
var vertShader = gl.createShader(gl.VERTEX_SHADER);
gl.shaderSource(vertShader, vertCode);
gl.compileShader(vertShader);
if (!gl.getShaderParameter(vertShader, gl.COMPILE_STATUS)){
   throw new Error(gl.getShaderInfoLog(vertShader));
}

```

<script>方式

```
  <!-- Vertex shader program -->
<script id="vshader" type="x-shader/x-vertex">
    ※顶点着色器
</script>

<!-- Fragment shader program -->
<script id="fshader" type="x-shader/x-fragment">
    ※片段着色器
</script>

```

将shader attach到WebGL的语境中

```
var shaderProgram = gl.createProgram();
gl.attachShader(shaderProgram, vertShader);
gl.attachShader(shaderProgram, fragShader);
gl.linkProgram(shaderProgram);
if (!gl.getProgramParameter(shaderProgram, gl.LINK_STATUS))
   throw new Error(gl.getProgramInfoLog(shaderProgram));

```

使用Js建立矩阵数组

例如一个正方体的模型数组包含:顶点矩阵、法线矩阵(可选)、像素矩阵和索引矩阵（也可选，但不建议）

```
function makeBox(ctx)
{
    // box
    //    v6----- v5
    //   /|      /|
    //  v1------v0|
    //  | |     | |
    //  | |v7---|-|v4
    //  |/      |/
    //  v2------v3
    //
    // vertex coords array
    var vertices = new Float32Array(
        [  1, 1, 1,  -1, 1, 1,  -1,-1, 1,   1,-1, 1,    // v0-v1-v2-v3 front
           1, 1, 1,   1,-1, 1,   1,-1,-1,   1, 1,-1,    // v0-v3-v4-v5 right
           1, 1, 1,   1, 1,-1,  -1, 1,-1,  -1, 1, 1,    // v0-v5-v6-v1 top
          -1, 1, 1,  -1, 1,-1,  -1,-1,-1,  -1,-1, 1,    // v1-v6-v7-v2 left
          -1,-1,-1,   1,-1,-1,   1,-1, 1,  -1,-1, 1,    // v7-v4-v3-v2 bottom
           1,-1,-1,  -1,-1,-1,  -1, 1,-1,   1, 1,-1 ]   // v4-v7-v6-v5 back
    );

    // normal array
    var normals = new Float32Array(
        [  0, 0, 1,   0, 0, 1,   0, 0, 1,   0, 0, 1,     // v0-v1-v2-v3 front
           1, 0, 0,   1, 0, 0,   1, 0, 0,   1, 0, 0,     // v0-v3-v4-v5 right
           0, 1, 0,   0, 1, 0,   0, 1, 0,   0, 1, 0,     // v0-v5-v6-v1 top
          -1, 0, 0,  -1, 0, 0,  -1, 0, 0,  -1, 0, 0,     // v1-v6-v7-v2 left
           0,-1, 0,   0,-1, 0,   0,-1, 0,   0,-1, 0,     // v7-v4-v3-v2 bottom
           0, 0,-1,   0, 0,-1,   0, 0,-1,   0, 0,-1 ]    // v4-v7-v6-v5 back
       );

    // texCoord array
    var texCoords = new Float32Array(
        [  1, 1,   0, 1,   0, 0,   1, 0,    // v0-v1-v2-v3 front
           0, 1,   0, 0,   1, 0,   1, 1,    // v0-v3-v4-v5 right
           1, 0,   1, 1,   0, 1,   0, 0,    // v0-v5-v6-v1 top
           1, 1,   0, 1,   0, 0,   1, 0,    // v1-v6-v7-v2 left
           0, 0,   1, 0,   1, 1,   0, 1,    // v7-v4-v3-v2 bottom
           0, 0,   1, 0,   1, 1,   0, 1 ]   // v4-v7-v6-v5 back
       );

    // index array
    var indices = new Uint8Array(
        [  0, 1, 2,   0, 2, 3,    // front
           4, 5, 6,   4, 6, 7,    // right
           8, 9,10,   8,10,11,    // top
          12,13,14,  12,14,15,    // left
          16,17,18,  16,18,19,    // bottom
          20,21,22,  20,22,23 ]   // back
      );

    var retval = { };

    retval.normalObject = ctx.createBuffer();
    ctx.bindBuffer(ctx.ARRAY_BUFFER, retval.normalObject);
    ctx.bufferData(ctx.ARRAY_BUFFER, normals, ctx.STATIC_DRAW);

    retval.texCoordObject = ctx.createBuffer();
    ctx.bindBuffer(ctx.ARRAY_BUFFER, retval.texCoordObject);
    ctx.bufferData(ctx.ARRAY_BUFFER, texCoords, ctx.STATIC_DRAW);

    retval.vertexObject = ctx.createBuffer();
    ctx.bindBuffer(ctx.ARRAY_BUFFER, retval.vertexObject);
    ctx.bufferData(ctx.ARRAY_BUFFER, vertices, ctx.STATIC_DRAW);

    ctx.bindBuffer(ctx.ARRAY_BUFFER, null);

    retval.indexObject = ctx.createBuffer();
    ctx.bindBuffer(ctx.ELEMENT_ARRAY_BUFFER, retval.indexObject);
    ctx.bufferData(ctx.ELEMENT_ARRAY_BUFFER, indices, ctx.STATIC_DRAW);
    ctx.bindBuffer(ctx.ELEMENT_ARRAY_BUFFER, null);

    retval.numIndices = indices.length;

    return retval;
}

```

所以就有个问题，每当需要一个不同形状的物体都需要创建这样的模型。

WebGL只能描绘三种模型

- 点

- 线

- 三角形

所以一个正方形可以通过两个三角形来实现，如图

Initialize the Buffers

什么是buffer?

答：这里的buffer类似于动画的帧，每一个buffer就是一帧，由于是动画，所以就有图形，在buffer中我们主要设定图形的顶点缓存（VBO（vertex buffer object））。另外还有帧缓存和索引缓存IBO（index buffer objact）。

顶点属性的个数和生成VBO的个数是一致的，如果顶点中有三个属性，那么就需要三个VBO，因为顶点属性必须通过VBO来传给顶点着色器。

顶点缓存的处理流程:

・顶点的各种信息保存到数组里

・使用WebGL的方法生成VBO

・使用WebGL的方法将数组中的信息传给VBO

・顶点着色器中的attribute函数和VBO结合

初始化buffer的过程？

答：create -> bind -> bufferData

```
var vertices = [
   0.0, 0.5,
   0.5,  -0.5,
   -0.5, -0.5,
];
var buffer = gl.createBuffer();
gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertices), gl.STATIC_DRAW);

```

具体的坐标设定是怎样的？

答：如上面的 vertices 变量，实际上设定的一个三角形。

MATRIX建立矩阵模型

模型的放大、缩小、旋转都可以在矩阵中定义。

创建矩阵

初始化矩阵

做一个向X轴运动的操作  m.translate(Matrix, [1.0, 0.0, 0.0], Matrix); OpenGL的矩阵采用列向量，具体的操作流程应该是这样 移动>旋转>扩大缩小

视图变换

投影变换

矩阵相乘，得到最终需要变换的矩阵 multiply，相乘的顺序很重要，应是  P * V * M

Drawing

```
//净化背景色
gl.clearColor(0.0, 0.0, 0.0, 1.0);
gl.clear(gl.COLOR_BUFFER_BIT);
//使用之前定义的shader program
gl.useProgram(shaderProgram);
//使用buffer
var coordinatesVar = gl.getAttribLocation(shaderProgram, "coordinates");
gl.enableVertexAttribArray(coordinatesVar);
gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
gl.vertexAttribPointer(coordinatesVar, 2, gl.FLOAT, false, 0, 0);
//开始画
gl.drawArrays(gl.TRIANGLES, 0, 3);

```

**WebGL的工作流程就是如此:**

劣势：

1.学习资源太少，就连官方也只是给了一个物体转动的例子，后面就没有了，然后就让你去github了，手册都没有，不过火狐到很给力，给了个非常不错的tutorial，而且给出了WebGL API的列表https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API。

2.学习成本比较高，按照上面给出的难点星级，首先需要懂一些GLSL的入门语法，WebGL本身的东西还好，矩阵的计算也还好，最关键的问题是整个工作流程环环相扣，一个地方出问题就会跑不通。而且相对于暴露出来的错误，解决资源Google也不是太好找到。

3.这种3D动画，代码量当然不会少（比如建立模型），不过WebGL也给出了一些比如索引缓存等方案能稍微解决点问题。

优势就不说了。

**那WebGL还可以做什么?**

除了可以做这种单页的酷炫demo外，还可以和后端交互，随着后端数据动态变化也是可以的。

**总结**

我的调研还是比较底层的，当然还是有很多第三方库，比如D3.js，Three.js，DirectX.js，它们的存在估计会很大程度上降低学习成本，不过还是很有收获。

WebGL技术调研
