---
title: Python 进阶
date: 2017-01-17 23:31:45
tags:
categories:
---

Python 进阶学习笔记

<!--more-->

---


## 函数式编程

本节内容摘自[阮一峰](http://www.ruanyifeng.com/blog/)老师的文章：[函数式编程初探
](http://www.ruanyifeng.com/blog/2012/04/functional_programming.html)

简单说，"函数式编程"是一种"编程范式"（programming paradigm），也就是如何编写程序的方法论。

它属于"结构化编程"的一种，主要思想是把运算过程尽量写成一系列嵌套的函数调用。

### 特点

函数式编程具有五个鲜明的特点。

1. 函数是"第一等公民"
  所谓"第一等公民"（first class），指的是函数与其他数据类型一样，处于平等地位，可以赋值给其他变量，也可以作为参数，传入另一个函数，

  或者作为别的函数的返回值。举例来说，下面代码中的print变量就是一个函数，可以作为另一个函数的参数。

``` javascript
var print = function(i){ console.log(i);};

[1,2,3].forEach(print);
```

2. 只用"表达式"，不用"语句"
  "表达式"（expression）是一个单纯的运算过程，总是有返回值；"语句"（statement）是执行某种操作，没有返回值。函数式编程要求，

  只使用表达式，不使用语句。也就是说，每一步都是单纯的运算，而且都有返回值。原因是函数式编程的开发动机，一开始就是为了处理运算（computation），

  不考虑系统的读写（I/O）。"语句"属于对系统的读写操作，所以就被排斥在外。当然，实际应用中，不做I/O是不可能的。因此，编程过程中，

  函数式编程只要求把I/O限制到最小，不要有不必要的读写行为，保持计算过程的单纯性。

3. 没有"副作用"
  所谓"副作用"（side effect），指的是函数内部与外部互动（最典型的情况，就是修改全局变量的值），产生运算以外的其他结果。

  函数式编程强调没有"副作用"，意味着函数要保持独立，所有功能就是返回一个新的值，没有其他行为，尤其是不得修改外部变量的值。

4. 不修改状态
  上一点已经提到，函数式编程只是返回新的值，不修改系统变量。因此，不修改变量，也是它的一个重要特点。在其他类型的语言中，

  变量往往用来保存"状态"（state）。不修改变量，意味着状态不能保存在变量中。函数式编程使用参数保存状态，最好的例子就是递归。

  下面的代码是一个将字符串逆序排列的函数，它演示了不同的参数如何决定了运算所处的"状态"。由于使用了递归，函数式语言的运行速度比较慢，

  这是它长期不能在业界推广的主要原因。
  　
``` javascript
function reverse(string) {
　　　　if(string.length == 0) {
　　　　　　return string;
　　　　} else {
　　　　　　return reverse(string.substring(1, string.length)) + string.substring(0, 1);
　　　　}
　　}
```

5. 引用透明
  引用透明（Referential transparency），指的是函数的运行不依赖于外部变量或"状态"，只依赖于输入的参数，任何时候只要参数相同，

  引用函数所得到的返回值总是相同的。有了前面的第三点和第四点，这点是很显然的。其他类型的语言，函数的返回值往往与系统状态有关，

  不同的状态之下，返回值是不一样的。这就叫"引用不透明"，很不利于观察和理解程序的行为。


## 高阶函数

高阶函数：能够接收函数做参数的函数


## 闭包

将 g 的定义移入函数 f 内部，防止其他代码调用 g：

``` python
def f():
    print 'f()...'
    def g():
        print 'g()...'
    return g

def calc_sum(lst):
    def lazy_sum():
        return sum(lst)
    return lazy_sum
```

注意: 发现没法把 lazy_sum 移到 calc_sum 的外部，因为它引用了 calc_sum 的参数 lst。

像这种内层函数引用了外层函数的变量（参数也算变量），然后返回内层函数的情况，称为闭包（Closure）。

闭包的特点是返回的函数还引用了外层函数的局部变量，所以，要正确使用闭包，就要确保引用的局部变量在函数返回后不能变。考察如下代码:

``` python
# 希望一次返回3个函数，分别计算1x1,2x2,3x3:
def count():
    fs = []
    for i in range(1, 4):
        def f():
             return i*i
        fs.append(f)
    return fs

f1, f2, f3 = count()
```

实际结果全部都是 9（请自己动手验证）。

原因就是当count()函数返回了3个函数时，这3个函数所引用的变量 i 的值已经变成了3。由于f1、f2、f3并没有被调用，所以，此时他们并未计算 i*i，当 f1 被调用时：

``` python
f1()
9     # 因为f1现在才计算i*i，但现在i的值已经变为3
```


因此，返回函数不要引用任何循环变量，或者后续会发生变化的变量。

考察下面的函数 f:

``` python
def f(j):
    def g():
        return j*j
    return g
```

它可以正确地返回一个闭包g，g所引用的变量j不是循环变量，因此将正常执行。

在count函数的循环内部，如果借助f函数，就可以避免引用循环变量i。

参考代码:

``` python
def count():
    fs = []
    for i in range(1, 4):
        def f(j):
            def g():
                return j*j
            return g
        r = f(i)
        fs.append(r)
    return fs
f1, f2, f3 = count()
print f1(), f2(), f3()
```

## 匿名函数

高阶函数可以接收函数做参数，有些时候，我们不需要显式地定义函数，直接传入匿名函数更方便。

在Python中，对匿名函数提供了有限支持。就是只能有一个表达式，不写return，返回值就是该表达式的结果。

使用匿名函数可以简化代码，返回函数的时候，也可以返回匿名函数。

``` python
myabs = lambda x: -x if x < 0 else x
```

## 装饰器

Python的 decorator 本质上就是一个高阶函数，它接收一个函数作为参数，然后，返回一个新函数。

使用 decorator 用Python提供的 @ 语法，这样可以避免手动编写 f = decorate(f) 这样的代码。

要让 \@log 自适应任何参数定义的函数，可以利用Python的 \*args 和 \*\*kw，保证任意个数的参数总是能正常调用：

``` python
def log(f):
    def fn(*args, **kw):
        print 'call ' + f.__name__ + '()...'
        return f(*args, **kw)
    return fn
```

现在，对于任意函数，\@log 都能正常工作。

考察 \@log 装饰器：

``` python
def log(f):
    def fn(x):
        print 'call ' + f.__name__ + '()...'
        return f(x)
    return fn
```

发现对于被装饰的函数，log打印的语句是不能变的（除了函数名）。

如果有的函数非常重要，希望打印出'[INFO] call xxx()...'，有的函数不太重要，希望打印出'[DEBUG] call xxx()...'，这时，log函数本身就需要传入'INFO'或'DEBUG'这样的参数，类似这样：

```python
@log('DEBUG')
def my_func():
    pass
```

把上面的定义翻译成高阶函数的调用，就是：

```python
my_func = log('DEBUG')(my_func)
```

上面的语句看上去还是比较绕，再展开一下：

```python
log_decorator = log('DEBUG')
my_func = log_decorator(my_func)
```

上面的语句又相当于：

```python
log_decorator = log('DEBUG')
@log_decorator
def my_func():
    pass
```

所以，带参数的log函数首先返回一个decorator函数，再让这个decorator函数接收my_func并返回新函数：

```python
def log(prefix):
    def log_decorator(f):
        def wrapper(*args, **kw):
            print '[%s] %s()...' % (prefix, f.__name__)
            return f(*args, **kw)
        return wrapper
    return log_decorator

@log('DEBUG')
def test():
    pass
print test()
```

执行结果：

```
[DEBUG] test()...
None
```

对于这种3层嵌套的decorator定义，你可以先把它拆开：

```python
# 标准decorator:
def log_decorator(f):
    def wrapper(*args, **kw):
        print '[%s] %s()...' % (prefix, f.__name__)
        return f(*args, **kw)
    return wrapper
return log_decorator

# 返回decorator:
def log(prefix):
    return log_decorator(f)
```

拆开以后会发现，调用会失败，因为在3层嵌套的decorator定义中，最内层的wrapper引用了最外层的参数prefix，所以，把一个闭包拆成普通的函数调用会比较困难。不支持闭包的编程语言要实现同样的功能就需要更多的代码。


## 偏函数

当一个函数有很多参数时，调用者就需要提供多个参数。如果减少参数个数，就可以简化调用者的负担。

functools.partial可以把一个参数多的函数变成一个参数少的新函数，少的参数需要在创建时指定默认值，这样，新函数调用的难度就降低了。


# 面向对象

The pass statement
pass is a null operation — when it is executed, nothing happens. It is useful as a placeholder when a statement is required syntactically, but no code needs to be executed, for example:

```
def f(arg): pass    # a function that does nothing (yet)
class C: pass       # a class with no methods (yet)
```






## 附录: Python 内置函数

1. abs(v)

  求绝对值

2. math.sqrt(v)

  求平方根

3. map(f, L)

  Python 内置的高阶函数，它接收一个函数 f 和一个 list，并通过把函数 f 依次作用在 list 的每个元素上，得到一个新的 list 并返回。

  注意了 在py3中需要使用 list()转换map(), 例如 print(list(map(format_name, ['adam', 'LISA', 'barT']))

4. capitalize()

  首字母大写，其余全部小写

5. upper()

  全转换成大写

  lower()

  全转换成小写

6. title()

  标题首字大写，如"i love python".title()  "I love python"

7. reduce(f, L)

  Python内置的一个高阶函数。reduce()函数接收的参数和 map()类似，一个函数 f，一个list，

  但行为和 map()不同，reduce()传入的函数 f 必须接收两个参数，reduce()对list的每个元素反复调用函数f，并返回最终结果值。

  reduce()还可以接收第3个可选参数，作为计算的初始值。

  python3中，要使用reduce,得从functools中引入，加上 from functools import reduce 才能够用。

8. filter(f, L)

  Python 内置的另一个有用的高阶函数，filter()函数接收一个函数 f 和一个list，这个函数 f 的作用是对每个元素进行判断，

  返回 True或 False，filter()根据判断结果自动过滤掉不符合条件的元素，返回由符合条件元素组成的新list。

9. str.strip(rm)

  删除 str 字符串中开头、结尾处的 rm 序列的字符。当rm为空时，默认删除空白符（包括'\n', '\r', '\t', ' ')

10. int(v)

  截取整数部分

11. sorted(iterable[, cmp[, key[, reverse]]])

  Python 内置高阶函数,它可以接收一个比较函数来实现自定义排序，比较函数的定义是，传入两个待比较的元素 x, y，

  如果 x 应该排在 y 的前面，返回 -1，如果 x 应该排在 y 的后面，返回 1。如果 x 和 y 相等，返回 0。

12. cmp(x, y)

  比较函数


## 与 Python3 不同之处

1. python3里 / 结果是浮点数  // 结果是整数
