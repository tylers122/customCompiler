# customCompiler
A custom compiler for CS152
# Nucleo Programming Language Specification

## Introduction

Nucleo is a statically-typed programming language designed for systems programming and software development. It features a simple syntax, powerful abstractions, and a rich set of libraries and tools.

## Language Features

### Variables

Variables in Nucleo are declared using the `var` keywords followed by the variable name and an optional initial value:

var x = 5;

### Constants

Constants in Nucleo are declared using the `const` keyword followed by the constant name and an initial value:

const PI = 3.14;\
const MY_NAME = "John";

### Arithmetic operators

Nucleo supports the following arithmetic operators: `+`, `-`, `*`, `/`, `%`.

x + y\
x - y\
x * y\
x / y\
x % y

### Increment and decrement

Nucleo supports the following increment and decrement operators: `++`, `--`.

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

### Read and Write statements

Nucleo supports write and write statements using the keywords `print` and `input`:

print("Example text")\
input()

### Conditional statements

Nucleo supports if-then-else statements using the `if` keyword:

if (x < y) {\
&ensp; // do something\
} else {\
&ensp; // do something else\
}

### Loops

Nucleo supports while and for loops (including "break" and "continue" loop control statements):

while (x < y) {\
&ensp; // do something\
&ensp; break;\
}

for (let i = 0; i < n; i++) {\
&ensp; // do something\
&ensp; continue;\
}

### Functions

Functions in Nucleo are declared using the `fn` keyword followed by the function name, a list of parameters enclosed in parentheses, and an optional return type:

fn add(x, y) -> int {\
&ensp; return x + y;\
}

### Arrays

Arrays in Nucleo are declared using square brackets `[]`:

var arr: int[10];

### Import and export modules

Modules can be imported and exported using the `import` and `export` keywords:

import { add } from "./math.nc";\
export const PI = 3.14;


### Comments

Comments in Nucleo can be either single-line comments starting with `//` or multi-line comments starting with `/*` and ending with `*/`:

// This is a single line comment\
/* This is\
a\
multi-line\
comment */

### Tokens

Here is a table showing the token for each symbol in the language:
| Symbol   | Token Name   |
|----------|--------------|
| var      | VAR          |
| +        | PLUS         |
| -        | MINUS        |
| *        | MULT         |
| /        | DIV          |
| %        | MOD          |
| =        | ASSIGN       |
| +=       | PLUS_ASSIGN  |
| -=       | MINUS_ASSIGN |
| \*=       | MULT_ASSIGN  |
| /=       | DIV_ASSIGN   |
| %=       | MOD_ASSIGN   |
| ++       | INCREMENT    |
| --       | DECREMENT    |
| ==       | EQ           |
| !=       | NEQ          |
| <        | LT           |
| >        | GT           |
| <=       | LTE          |
| >=       | GTE          |
| &&       | AND          |
| \|\|     | OR           |
| !        | NOT          |
| (        | LPAREN       |
| )        | RPAREN       |
| {        | LBRACE       |
| }        | RBRACE       |
| \[        | LBRACK       |
| \]        | RBRACK       |
| :        | COLON        |
| print    | PRINT        |
| input    | INPUT        |
| while    | WHILE        |
| for      | FOR          |
| break    | BREAK        |
| continue | CONT         |
| if       | IF           |
| else     | ELSE         |
| import   | IMPORT       |
| export   | EXPORT       |
| fn       | FUNC         |
| return   | RETURN       |

### References

https://www.cs.ucr.edu/~dtan004/proj1/phase1_lexer.html
