S-expression Calculator
=======================

Command line program that takes a single argument as an expression and prints out the integer result of evaluating it.

Installation
--------

```shell
git clone https://github.com/iOSDevKamal/S-Expression-Calculator
cd S-Expression-Calculator
swift run expression
```

Examples
--------

```console
kamal@macbook S-Expression-Calculator % swift run expression 123
123

kamal@macbook S-Expression-Calculator % swift run expression "(add 2 3)"
5

kamal@macbook S-Expression-Calculator % swift run expression "(multiply 3 4)"
12

kamal@macbook S-Expression-Calculator % swift run expression "(add 1 (multiply 2 3))"
7

kamal@macbook S-Expression-Calculator % swift run expression "(multiply 2 (add (multiply 2 3) 8))"
28
```
