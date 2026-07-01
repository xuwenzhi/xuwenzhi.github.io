---
layout: post
title: "Dependency Injection In PHP"
tags: php design-pattern
---

	    Dependency Injection（依赖注入），这是一个存在了超久的软件设计方法，但是我也是前一段时间才听说过，虽然听起来有些高大上，但是大家在之前的面向对象设计过程中，或多或少都可能会有依赖注入的影子，所以并不是特别难懂的概念。

	    这篇文章并不会详细的介绍依赖注入的具体概念，只列了一段小代码介绍。同时把一些我看到的比较不错的文章和博文列举到这里，相当于做一个传送门吧。

	 

	 

	**首先，理解什么是Dependency Injection?**

	        [What is Dependency Injection？](http://fabien.potencier.org/what-is-dependency-injection.html)

	        PS1:作者是**[Fabien Potencier](http://fabien.potencier.org/)，**Symfony框架的主要开发者，一个绝对可以让你献出膝盖的人物。当然由于Symfony中大量的实践了Dependency Injection，所以作者有相当实际的经验。

	        PS2:这是作者介绍Dependency Injection的第一篇，当你点进去的时候就会发现，作者写了6个部分来介绍，如果仅仅希望能够理解Dependency Injection概念的话，只看前两章即可。如果想深入Dependency Injection在symfony的实践经验，建议都看完。

	        PS3:很遗憾，是英文版。

	 

	**Dependency Injection究竟有什么好处？**

	我这里以一段代码在使用dependency injection之前和之后的变化介绍。

class User {

    /**

     * @var PDO The connection to the database

     */

    protected $db;

    /**

     * Construct.

     */

    public function __construct()

    {

                //构造方法中实例化$db

        $this->db = DB::getInstance();

    }

}

$obj_user = new User();

上面这段代码似乎没什么问题，绝对可以正常运行，但是其中一个重要的缺点是User类和DB类的耦合性会很强，同时我们对$db的实例化是硬编码的，这将导致以后的扩展性降低。而我们通常的设计方法是松耦合、可扩展的。So，这段代码有改进空间，那么是否依赖注入能够解决这样的问题呢？

再看下面重写后的代码，注意前方高能

class User {

    /**

     * @var PDO The connection to the database

     */

    protected $db;

    /**

     * Construct.

     * @param PDO $db_conn The database connection

     */

    public function __construct($dbConn)

    {

        $this->db = $dbConn;

    }

}

$dbConn = DB::getInstance();

$obj_user = new User($dbConn);

仔细再看这段代码，会发现，我们在构造方法中传入了$dbConn实例，User类只需使用这个实例即可，而无需关注$db究竟是如何实例化的且即便是DB类后期有改动，User类也无需关注。So，这种通过构造方法将实例作为参数注入到某个类中就是依赖注入，够高能吧，很简单的一个概念。

当然，除了通过构造方法(__construct())来进行注入之外，还有另外两种方法来实现注入，分别是属性注入(property)和方法注入(method)，看下面的例子感受下:

class User {

    /**

     * @var PDO The connection to the database

     */

    protected $db;

    public function __construct() {}

    /**

     * Sets the database connection

     * @param PDO $dbConn The connection to the database.

     */

    public function setDB($dbConn)

    {

        $this->db = $dbConn;

    }

}

$dbConn = DB::getInstance();

$obj_user = new User();

$obj_user->setDB($dbConn);
class User {

    /**

     * @var PDO The connection to the database

     */

    public $db;

    public function __construct() {}

}

$obj_user = new User();

$obj_user->db = DB::getInstance();

	 

	 

	 

	**Dependency Injection定理**

>

		依赖注入一般有三种方式的注入，构造注入(constructor)、属性注入(set property)和函数注入(method)一般来说，构造注入适合require类的依赖，属性注入适合可选的依赖，当然还有函数式依赖同样适合可选的依赖。

	PS:个人整理的关于依赖注入的一些定理。

	 

	 

	 

	**延伸阅读**

	[True Dependency Injection with Symfony Components](http://www.toptal.com/symfony/true-dependency-injection-symfony-components?utm_campaign=blog_post_true_dependency_injection_symfony_components&utm_medium=email&utm_source=blog_subscribers)

	    PS1:建议有一定symfony学习经验的读者看（如果是大拿可以略过），这篇文章对symfony的Dependency Injection进行了抽丝剥茧，对于理解symfony运行原理有帮助。

	    PS2:很遗憾，是英文版。

	 

	**参考网址:**

[laravel 学习笔记 —— 神奇的服务容器](https://www.insp.top/article/learn-laravel-container)

[Dependency Injection: Huh?](http://code.tutsplus.com/tutorials/dependency-injection-huh--net-26903)

[What is Dependency Injection？](http://fabien.potencier.org/what-is-dependency-injection.html)

[True Dependency Injection with Symfony Components](http://www.toptal.com/symfony/true-dependency-injection-symfony-components?utm_campaign=blog_post_true_dependency_injection_symfony_components&utm_medium=email&utm_source=blog_subscribers)

Dependency Injection In PHP
