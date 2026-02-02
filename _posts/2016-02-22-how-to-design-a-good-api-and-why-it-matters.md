---
layout: post
title: How to design a good API and why it matters
tags: design
---

# Why Does API Design Matter? How Should We Design APIs?

<!-- more -->

Joshua Bloch

[Principal Software Engineer - Google](http://xuwenzhi.com/wp-content/uploads/2015/12/How-to-design-a-good-API.pdf)

--

# Why API Design Matters

**APIs can significantly become a company's competitive advantage**

- A well-designed API can reduce the time developers need to understand it

- APIs cannot stop external access, so proper design must be done during the design phase

- A bad API can also bring negative impacts to the company

- External APIs are long-lasting; one change will affect many things

---

# Why Does API Design Matter to You?

- If you are an API designer, you should design the API system to be modular and component-based

- Modular code will greatly improve reusability

- Good API design can also improve code quality

---

# Characteristics of an Excellent API

- Easy to understand, highly readable

- Easy to use, preferably understandable without reading documentation

- Easy to read and maintainable

- Easy to extend

---

# How Should We Specifically Design APIs?

1. API Design Steps

2. General Principles

3. Class Design

4. Method Design

5. How to Handle Exceptions

--

## 1. API Design Steps

**You must fully understand requirements and possible future changes**

- You will often receive suggested solutions; remember, good solutions really do exist

- Strive to carefully categorize the collected requirements

- Good design is always the simplest; simplicity is beauty

**What should you do before coding?**

- Be prepared before coding; you might overturn your previous design

- Make sure you have effectively refined the API details before coding

- Continuously complete the API until all requirements are fulfilled

**Handle various exceptions in a practical manner**

- Try to foresee possible errors

- Your API may be used for a long time; try to anticipate future pitfalls and solve them!

# 2. General Principles

**An API should do one thing and do it well**

- Functionality should be simple and easy to understand

- If it's hard to name, that's usually a bad sign

- Good naming can drive our development work

- An API should be composed of multiple modules, organically separated

**Minimize everything**

- Ensure classes and their members are as private as possible

- Public classes should not have public members, except constants

- Hide as much class information as possible from the outside

- Ensure each module is usable, understandable, enhanceable, testable, and debuggable

**Names matter; an API is like a small language**

- Names should be as self-descriptive as possible

- Naming should follow patterns

- Code should read like prose

---

    if (car.speed() > 2 * SPEED_LIMIT)

    	generateAlert("Watch out for cops!");

---

**Documentation matters**

> Reusability is easier said than done. Achieving reusability requires good design and beautiful documentation. Good design is rare, but without good documentation, reusable modules are impossible. - D. L. Parnas, \_Software Aging. Proceedings of 16th International Conference Software Engineering, 1994

**API design should consider performance**

### What bad decisions affect performance

- Using mutable types

- Providing constructors instead of factories

- Using implementation types instead of interfaces

### Don't mess up the API just to improve performance

- Problems causing performance issues can be fixed, but distorted designs will exist forever

- Good design usually balances performance

**An API should integrate well with its operating environment**

### Follow conventions

- Comply with standards

- Avoid unusual parameters and return values

- Emulate core API and language styles

# 3. Class Design

**Minimize mutability**

- Unless there's a good reason, don't modify a well-designed class

- If changes are necessary, keep classes small, well-defined, and with clear and reasonable function calls

```
Bad:

	Date, Calendar

Good:

	TimerTask
```

**Subclasses must have a reason to exist**

### Defining a subclass implies its substitution meaning

- Only define subclasses when meaningful relationships (like inheritance) truly exist

- Also, when inheriting, don't forget to consider if the composite pattern can be used

### Public classes should not be subclassed

```
Bad:

	Properties extends Hashtable

	Stack extends Vector
Good:

	Set extends Collection
```

**If you use inheritance, be sure to write design documentation**

### Inheritance violates encapsulation

- Because inheritance makes subclasses sensitive to the implementation details of parent classes

- The conservative approach: all classes should be final

```
Bad:

	Many concrete classes in J2SE libraries
Good:

	AbstractSet, AbstractMap

```

# 4. Method Design

### Don't let what a module should do be done by one method; split it up

### Don't violate the [Principle of Least Astonishment](http://programmers.stackexchange.com/questions/187457/what-is-the-principle-of-least-astonishment)

### When errors occur, report them as quickly as possible

### Use appropriate parameter types and return value types

- Use more specific parameter types

- If a better type exists, don't use strings

- Don't use float when representing currency amounts; it will cause precision issues

- double (64 bits) is better than float (32 bits)

- Consistent parameter types and order throughout the method are important

- Avoid long parameter lists, or keep the number of parameters as small as possible

- Avoid special return values; if the return value is empty, return an array(), don't return null

# 5. How to Handle Exceptions

Throwing an exception means the program has entered abnormal conditions, but give the client a smooth handling result. Conversely, don't do nothing; at least logging is acceptable.

### Capture failure information in exceptions

- Allow diagnosis, fixing, and recovery

- For unchecked exceptions, $e->message() is sufficient

- For checked exceptions, providing information to the caller is best
