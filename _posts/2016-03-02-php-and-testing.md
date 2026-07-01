---
layout: post
title: "PHP与测试"
tags: php testing
---

如果经常上github的话，会经常发现某些开源项目的根目录下会有个test，这个目录下就是针对开源项目的自动化测试。那么为什么要写测试？对于一个开源项目而言，有自动化测试最起码给人一种靠谱的感觉，增加使用者的信任感。写自动化测试这种优良风气在国内很少见，而这种工作也一般掌握在QA手里，然而写自动化测试在我看来应该是RD的任务，验证自己的代码质量是对自己和团队负责的表现。同时自动化测试也可以帮助我们对软件的重构工作，所以测试是一项重要的事情。在这里并不会教你如何写自动化测试，而主要列举一些测试相关的简单概念，以及常用的PHP的测试框架及选型。请迅速上车~

**测试驱动开发Test Driven Development**

>

测试驱动开发（TDD）是一个软件开发的流程，依赖于极短的开发周期迭代：首先开发人员编写预期的改进和新功能的自动化测试用例，然后编写具体的代码，以这个测试用例为基准完成功能，并最终通过重构以得到可接受的标准。

**单元测试Unit Testing**

单元测试主要对具体的某一个函数，某一个类或者某一个模块进行测试，测试的粒度很小，精度高！

最常用和熟悉的测试框架可能就是PHPUnit了，但PHPUnit相对来说较为庞大，如果是一个小的开源项目根本无需用到这样重型的框架，而可以选用较轻量的比如SimpleTest。

- [PHPUnit](http://phpunit.de)

- [atoum](https://github.com/atoum/atoum)

- [Kahlan](https://github.com/crysalead/kahlan)

- [Peridot](http://peridot-php.github.io/)

- [SimpleTest](http://simpletest.org)

**集成测试Integration Testing**

- 有些单元测试工具，也可以被拿来用于集成测试。

- 集成测试一般在单元测试之后，验证测试之前。

- 测试粒度相对于单元测试要粗些

**功能性测试Functional Testing**

- [Selenium](http://seleniumhq.com)

- [Mink](http://mink.behat.org)

- [Codeception](http://codeception.com) 是一个包含验收测试工具的全栈型框架

- [Storyplayer](http://datasift.github.io/storyplayer) 是一个支持创建和销毁测试环境的全栈型框架。

**行为驱动开发Behavior Driven Development**

**SpecBDD**

着重于代码技术上的行为。

顾名思义，需要落实到具体的代码。主要可以用于引导类、函数等功能的行为。这方面的框架有[PHPSpec](http://www.phpspec.net/en/latest/)

**StoryBDD**

着重于商业需求上的行为。

顾名思义，类似于写故事，或者称为伪码，使用人类可读语言描述应用的行为，并且惊奇的是这些伪码可以在应用中运行。这方面的框架[Behat](http://docs.behat.org/en/v3.0/)。

**互补的测试框架**

- [Selenium](http://seleniumhq.org/)一个浏览器自动工具，[能与PHPUnit集成](https://github.com/giorgiosironi/phpunit-selenium/)

- [Mockery](https://github.com/padraic/mockery) 是一个能与[PHPUnit](http://phpunit.de/)或[PHPSpec](http://www.phpspec.net/)集成的Mock对象测试框架

- [Prophecy](https://github.com/phpspec/prophecy)是一个非常强大和灵活的Mock对象测试框架，能够与[PHPSpec](http://www.phpspec.net/)集成和能够与[PHPUnit](http://phpunit.de/)搭配使用。

PHP与测试
