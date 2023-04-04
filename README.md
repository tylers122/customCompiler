# customCompiler
A custom compiler for CS152
# Nucleo Programming Language Specification

## Introduction

Nucleo is a statically-typed programming language designed for systems programming and software development. It features a simple syntax, powerful abstractions, and a rich set of libraries and tools.

## Language Features

### Variables

Variables in Nucleo are declared using the `let` or `var` keywords followed by the variable name and an optional initial value:

let x = 5;\
var y = "hello";

### Constants

Constants in Nucleo are declared using the `const` keyword followed by the constant name and an initial value:

const PI = 3.14;\
const MY_NAME = "John";

### Arithmetic operators

Nucleo supports the following arithmetic operators: `+`, `-`, `*`, `/`.

x + y\
x - y\
x * y\
x / y

### Increment and decrement

Nucleo supports the following increment and decrement operators: `++`, `--`, `++x`, `--x`.

x++\
x--\
++x\
--x

### Relational operators

Nucleo supports the following relational operators: `<`, `<=`, `>`, `>=`, `==`, `!=`.

x < y\
x <= y\
x > y\
x >= y\
x == y\
x != y

### Logical operators

Nucleo supports the following logical operators: `&&`, `||`, `!`.

x && y\
x || y\
!x

### Conditional statements

Nucleo supports if-then-else statements using the `if` keyword:

if (x < y) {
// do something
} else {
// do something else
}


### Switch statements

Nucleo supports switch statements:

switch (x) {
case 1:
// do something
break;
case 2:
// do something else
break;
default:
// do something else
break;
}

### Loops

Nucleo supports while and for loops:

while (x < y) {
// do something
}

for (let i = 0; i < n; i++) {
// do something
}

### Functions

Functions in Nucleo are declared using the `fn` keyword followed by the function name, a list of parameters enclosed in parentheses, and an optional return type:

fn add(x: int, y: int) -> int {
return x + y;
}


### Arrays

Arrays in Nucleo are declared using square brackets `[]`:

let arr: int[10];
let matrix: int[2][2];

### Structs

Structs in Nucleo are declared using the `struct` keyword:

struct Point {
x: int,
y: int
}

### Enums

Enums in Nucleo are declared using the `enum` keyword:

enum Color {
RED,
GREEN,
BLUE
}

### Import and export modules

Modules can be imported and exported using the `import` and `export` keywords:

import { add } from "./math.nc";
export const PI = 3.14;


### Comments

Comments in Nucleo can be either single-line comments starting with `//` or multi-line comments starting with `/*` and ending with `*/`:

// This is a single line comment
/* This is
a
multi-line
comment
