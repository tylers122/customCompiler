/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison implementation for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "3.0.4"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Push parsers.  */
#define YYPUSH 0

/* Pull parsers.  */
#define YYPULL 1




/* Copy the first part of user declarations.  */
#line 1 "compiler.y" /* yacc.c:339  */

#include <stdio.h>
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
#include <vector>
#include <string>
#include <iostream>
#include <sstream>

extern FILE* yyin;
extern int yylex(void);
extern int yylineno;
extern int curr_col;
void yyerror(const char* s);

char *identToken;
int numberToken;
int  count_names = 0;

enum Type { Integer, Array };

struct Symbol {
  std::string name;
  Type type;
};

struct Function {
  std::string name;
  std::vector<Symbol> arguments;
};

std::vector <Function> symbol_table;
Function *get_function() {
  int last = symbol_table.size()-1;
  if (last < 0) {
    printf("***Error. Attempt to call get_function with an empty symbol table\n");
    printf("Create a 'Function' object using 'add_function_to_symbol_table' before\n");
    printf("calling 'find' or 'add_variable_to_symbol_table'");
    exit(1);
  }
  return &symbol_table[last];
}

bool find(std::string &value) {
  Function *f = get_function();
  for(int i=0; i < f->arguments.size(); i++) {
    Symbol *s = &f->arguments[i];
    if (s->name == value) {
      return true;
    }
  }
  return false;
}

bool find(std::string &value, Type t) {
  Function *f = get_function();
  for(int i=0; i < f->arguments.size(); i++) {
    Symbol *s = &f->arguments[i];
    if (s->name == value && s->type == t) {
      return true;
    }
  }
  return false;
}

void add_function_to_symbol_table(std::string &value) {
  Function f; 
  f.name = value; 
  symbol_table.push_back(f);
}

void add_variable_to_symbol_table(std::string &value, Type t) {
  Symbol s;
  s.name = value;
  s.type = t;
  Function *f = get_function();
  f->arguments.push_back(s);
}


void print_symbol_table(void) {
  printf("symbol table:\n");
  printf("--------------------\n");
  for(int i=0; i<symbol_table.size(); i++) {
    printf("function: %s\n", symbol_table[i].name.c_str());
    for(int j=0; j<symbol_table[i].arguments.size(); j++) {
      printf("  locals: %s\n", symbol_table[i].arguments[j].name.c_str());
    }
  }
  printf("--------------------\n");
}

struct CodeNode {
    std::string code; // generated code as a string.
    std::string name;
};


std::string create_temp() {
        static int num = 0;
        std::ostringstream ss;
        ss << num;
        std::string value = "_temp" + ss.str();
        num += 1;
        return value;
}

std::string decl_temp(std::string &temp){
        return std::string(". ") + temp + std::string("\n");
}

#line 179 "y.tab.c" /* yacc.c:339  */

# ifndef YY_NULLPTR
#  if defined __cplusplus && 201103L <= __cplusplus
#   define YY_NULLPTR nullptr
#  else
#   define YY_NULLPTR 0
#  endif
# endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 1
#endif

/* In a future release of Bison, this section will be replaced
   by #include "y.tab.h".  */
#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INVALID_IDENT = 258,
    INVALID_TOKEN = 259,
    PRINT = 260,
    INPUT = 261,
    WHILE = 262,
    FOR = 263,
    BREAK = 264,
    CONT = 265,
    IF = 266,
    ELSE = 267,
    IMPORT = 268,
    EXPORT = 269,
    FUNC = 270,
    RETURN = 271,
    VAR = 272,
    PLUS = 273,
    MINUS = 274,
    MULT = 275,
    DIV = 276,
    MOD = 277,
    ASSIGN = 278,
    PLUS_ASSIGN = 279,
    MINUS_ASSIGN = 280,
    MULT_ASSIGN = 281,
    DIV_ASSIGN = 282,
    MOD_ASSIGN = 283,
    INCREMENT = 284,
    DECREMENT = 285,
    EQ = 286,
    NEQ = 287,
    LT = 288,
    GT = 289,
    LTE = 290,
    GTE = 291,
    AND = 292,
    OR = 293,
    NOT = 294,
    LPAREN = 295,
    RPAREN = 296,
    LBRACE = 297,
    RBRACE = 298,
    LBRACK = 299,
    RBRACK = 300,
    COLON = 301,
    SEMICOLON = 302,
    COMMA = 303,
    NUMBER = 304,
    IDENT = 305
  };
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 115 "compiler.y" /* yacc.c:355  */

  char *op_val;
  struct CodeNode *node;

#line 275 "y.tab.c" /* yacc.c:355  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */

/* Copy the second part of user declarations.  */

#line 292 "y.tab.c" /* yacc.c:358  */

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#else
typedef signed char yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(Msgid) dgettext ("bison-runtime", Msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(Msgid) Msgid
# endif
#endif

#ifndef YY_ATTRIBUTE
# if (defined __GNUC__                                               \
      && (2 < __GNUC__ || (__GNUC__ == 2 && 96 <= __GNUC_MINOR__)))  \
     || defined __SUNPRO_C && 0x5110 <= __SUNPRO_C
#  define YY_ATTRIBUTE(Spec) __attribute__(Spec)
# else
#  define YY_ATTRIBUTE(Spec) /* empty */
# endif
#endif

#ifndef YY_ATTRIBUTE_PURE
# define YY_ATTRIBUTE_PURE   YY_ATTRIBUTE ((__pure__))
#endif

#ifndef YY_ATTRIBUTE_UNUSED
# define YY_ATTRIBUTE_UNUSED YY_ATTRIBUTE ((__unused__))
#endif

#if !defined _Noreturn \
     && (!defined __STDC_VERSION__ || __STDC_VERSION__ < 201112)
# if defined _MSC_VER && 1200 <= _MSC_VER
#  define _Noreturn __declspec (noreturn)
# else
#  define _Noreturn YY_ATTRIBUTE ((__noreturn__))
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(E) ((void) (E))
#else
# define YYUSE(E) /* empty */
#endif

#if defined __GNUC__ && 407 <= __GNUC__ * 100 + __GNUC_MINOR__
/* Suppress an incorrect diagnostic about yylval being uninitialized.  */
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN \
    _Pragma ("GCC diagnostic push") \
    _Pragma ("GCC diagnostic ignored \"-Wuninitialized\"")\
    _Pragma ("GCC diagnostic ignored \"-Wmaybe-uninitialized\"")
# define YY_IGNORE_MAYBE_UNINITIALIZED_END \
    _Pragma ("GCC diagnostic pop")
#else
# define YY_INITIAL_VALUE(Value) Value
#endif
#ifndef YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
# define YY_IGNORE_MAYBE_UNINITIALIZED_END
#endif
#ifndef YY_INITIAL_VALUE
# define YY_INITIAL_VALUE(Value) /* Nothing. */
#endif


#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined EXIT_SUCCESS
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
      /* Use EXIT_SUCCESS as a witness for stdlib.h.  */
#     ifndef EXIT_SUCCESS
#      define EXIT_SUCCESS 0
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's 'empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined EXIT_SUCCESS \
       && ! ((defined YYMALLOC || defined malloc) \
             && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef EXIT_SUCCESS
#    define EXIT_SUCCESS 0
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined EXIT_SUCCESS
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined EXIT_SUCCESS
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
         || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss_alloc;
  YYSTYPE yyvs_alloc;
};

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

# define YYCOPY_NEEDED 1

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack_alloc, Stack)                           \
    do                                                                  \
      {                                                                 \
        YYSIZE_T yynewbytes;                                            \
        YYCOPY (&yyptr->Stack_alloc, Stack, yysize);                    \
        Stack = &yyptr->Stack_alloc;                                    \
        yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
        yyptr += yynewbytes / sizeof (*yyptr);                          \
      }                                                                 \
    while (0)

#endif

#if defined YYCOPY_NEEDED && YYCOPY_NEEDED
/* Copy COUNT objects from SRC to DST.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(Dst, Src, Count) \
      __builtin_memcpy (Dst, Src, (Count) * sizeof (*(Src)))
#  else
#   define YYCOPY(Dst, Src, Count)              \
      do                                        \
        {                                       \
          YYSIZE_T yyi;                         \
          for (yyi = 0; yyi < (Count); yyi++)   \
            (Dst)[yyi] = (Src)[yyi];            \
        }                                       \
      while (0)
#  endif
# endif
#endif /* !YYCOPY_NEEDED */

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  7
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   133

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  51
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  31
/* YYNRULES -- Number of rules.  */
#define YYNRULES  68
/* YYNSTATES -- Number of states.  */
#define YYNSTATES  130

/* YYTRANSLATE[YYX] -- Symbol number corresponding to YYX as returned
   by yylex, with out-of-bounds checking.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   305

#define YYTRANSLATE(YYX)                                                \
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[TOKEN-NUM] -- Symbol number corresponding to TOKEN-NUM
   as returned by yylex, without out-of-bounds checking.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50
};

#if YYDEBUG
  /* YYRLINE[YYN] -- Source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   163,   163,   172,   176,   188,   205,   213,   218,   249,
     254,   266,   281,   286,   298,   306,   314,   322,   330,   334,
     338,   342,   346,   357,   365,   373,   384,   407,   423,   428,
     440,   450,   461,   466,   469,   475,   480,   485,   490,   504,
     511,   520,   528,   536,   555,   563,   572,   581,   590,   600,
     609,   618,   628,   640,   648,   657,   669,   677,   686,   695,
     707,   717,   731,   743,   757,   762,   774,   779,   790
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || 1
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "INVALID_IDENT", "INVALID_TOKEN",
  "PRINT", "INPUT", "WHILE", "FOR", "BREAK", "CONT", "IF", "ELSE",
  "IMPORT", "EXPORT", "FUNC", "RETURN", "VAR", "PLUS", "MINUS", "MULT",
  "DIV", "MOD", "ASSIGN", "PLUS_ASSIGN", "MINUS_ASSIGN", "MULT_ASSIGN",
  "DIV_ASSIGN", "MOD_ASSIGN", "INCREMENT", "DECREMENT", "EQ", "NEQ", "LT",
  "GT", "LTE", "GTE", "AND", "OR", "NOT", "LPAREN", "RPAREN", "LBRACE",
  "RBRACE", "LBRACK", "RBRACK", "COLON", "SEMICOLON", "COMMA", "NUMBER",
  "IDENT", "$accept", "prog_start", "functions", "function", "func_ident",
  "arguments", "repeat_arguments", "argument", "statements", "statement",
  "var_declaration", "arr_declaration", "assign_statement",
  "print_statement", "input_statement", "if_statement", "else_statement",
  "while_statement", "break_statement", "continue_statement", "expression",
  "binary_expression", "add_expression", "mult_expression",
  "base_expression", "assign_var", "assign_arr", "function_call", "param",
  "params", "return_statement", YY_NULLPTR
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[NUM] -- (External) token number corresponding to the
   (internal) symbol number NUM (which must be that of a token).  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305
};
# endif

#define YYPACT_NINF -28

#define yypact_value_is_default(Yystate) \
  (!!((Yystate) == (-28)))

#define YYTABLE_NINF -1

#define yytable_value_is_error(Yytable_value) \
  0

  /* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
     STATE-NUM.  */
static const yytype_int8 yypact[] =
{
       2,    -4,    23,   -28,     2,   -28,    -5,   -28,   -28,    36,
       6,    16,    10,   -28,    18,    36,   -28,     9,    10,    40,
      41,    46,   -28,   -28,     0,     0,    42,   -12,    47,     9,
     -28,   -28,   -28,   -28,   -28,   -28,   -28,   -28,   -28,   -28,
     -28,   -28,   -28,     0,    44,     0,     0,   -28,   -13,   -28,
      49,   -28,   -28,    11,    22,   -28,     1,     0,     0,     0,
     -28,   -28,    38,    11,    53,    71,    82,     0,     9,     0,
       0,     0,     0,     0,     0,     0,   -28,    11,   -15,    54,
     -11,     0,     0,     0,     0,     0,     0,     0,     0,   -28,
     -28,    59,   -28,    -9,    78,    22,    22,   -28,   -28,   -28,
      11,     3,     0,   -28,   -28,    73,    11,    11,    11,    11,
      11,    11,    11,    11,     9,   -28,   110,   101,   -15,     0,
      83,    85,   -28,   -28,   -28,    11,   -28,     9,    86,   -28
};

  /* YYDEFACT[STATE-NUM] -- Default reduction number in state STATE-NUM.
     Performed when YYTABLE does not specify something else to do.  Zero
     means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       3,     0,     0,     2,     3,     6,     0,     1,     4,     7,
       0,     0,     9,    11,     0,     0,     8,    12,     9,     0,
       0,     0,    36,    37,     0,     0,     0,     0,     0,    12,
      14,    15,    16,    17,    18,    19,    20,    21,    24,    25,
      22,    23,    10,     0,     0,     0,     0,    39,    38,    41,
       0,    42,    60,    68,    53,    56,    28,     0,    64,     0,
       5,    13,     0,    44,     0,     0,     0,     0,    12,     0,
       0,     0,     0,     0,     0,     0,    26,    61,    66,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,    30,
      31,     0,    40,     0,     0,    54,    55,    57,    58,    59,
      29,     0,     0,    65,    63,     0,    45,    46,    47,    49,
      48,    50,    51,    52,    12,    43,    33,    28,    66,     0,
       0,     0,    32,    27,    67,    62,    35,    12,     0,    34
};

  /* YYPGOTO[NTERM-NUM].  */
static const yytype_int8 yypgoto[] =
{
     -28,   -28,   121,   -28,   -28,   -28,   112,   113,   -27,   -28,
     -28,   -28,    14,   -28,   -17,   -28,   -28,   -28,   -28,   -28,
     108,    32,   -20,    19,    12,   -28,   -28,   -16,   -28,    15,
     -28
};

  /* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int8 yydefgoto[] =
{
      -1,     2,     3,     4,     6,    11,    16,    12,    28,    29,
      30,    31,    76,    32,    49,    34,   122,    35,    36,    37,
      52,    62,    63,    54,    55,    38,    39,    51,    79,   103,
      41
};

  /* YYTABLE[YYPACT[STATE-NUM]] -- What to do in state STATE-NUM.  If
     positive, shift that token.  If negative, reduce the rule whose
     number is the opposite.  If YYTABLE_NINF, syntax error.  */
static const yytype_uint8 yytable[] =
{
      33,    40,    61,    69,    70,    53,    20,    69,    70,    69,
      70,    57,    33,    40,    19,    20,    21,     1,    22,    23,
      24,    69,    70,     7,    74,    25,    26,    58,    58,    69,
      70,    67,    59,   102,   105,     9,   115,    77,    78,    80,
      46,    94,    71,    72,    73,    75,     5,    93,   117,    47,
      48,    33,    40,    10,   100,   101,    13,    14,    15,    27,
      17,   106,   107,   108,   109,   110,   111,   112,   113,    81,
      82,    83,    84,    85,    86,    87,    88,    65,    66,    89,
      43,    44,   118,    97,    98,    99,    45,   120,    95,    96,
      60,    68,    56,    64,    90,   104,   119,    33,    40,   125,
     128,   114,    81,    82,    83,    84,    85,    86,    87,    88,
      33,    40,    91,    81,    82,    83,    84,    85,    86,    87,
      88,   116,   121,    92,    74,     8,   126,   127,    18,   129,
      42,   123,    50,   124
};

static const yytype_uint8 yycheck[] =
{
      17,    17,    29,    18,    19,    25,     6,    18,    19,    18,
      19,    23,    29,    29,     5,     6,     7,    15,     9,    10,
      11,    18,    19,     0,    23,    16,    17,    40,    40,    18,
      19,    44,    44,    48,    45,    40,    45,    57,    58,    59,
      40,    68,    20,    21,    22,    44,    50,    67,    45,    49,
      50,    68,    68,    17,    74,    75,    50,    41,    48,    50,
      42,    81,    82,    83,    84,    85,    86,    87,    88,    31,
      32,    33,    34,    35,    36,    37,    38,    45,    46,    41,
      40,    40,   102,    71,    72,    73,    40,   114,    69,    70,
      43,    42,    50,    49,    41,    41,    23,   114,   114,   119,
     127,    42,    31,    32,    33,    34,    35,    36,    37,    38,
     127,   127,    41,    31,    32,    33,    34,    35,    36,    37,
      38,    43,    12,    41,    23,     4,    43,    42,    15,    43,
      18,   117,    24,   118
};

  /* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
     symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    15,    52,    53,    54,    50,    55,     0,    53,    40,
      17,    56,    58,    50,    41,    48,    57,    42,    58,     5,
       6,     7,     9,    10,    11,    16,    17,    50,    59,    60,
      61,    62,    64,    65,    66,    68,    69,    70,    76,    77,
      78,    81,    57,    40,    40,    40,    40,    49,    50,    65,
      71,    78,    71,    73,    74,    75,    50,    23,    40,    44,
      43,    59,    72,    73,    49,    72,    72,    44,    42,    18,
      19,    20,    21,    22,    23,    44,    63,    73,    73,    79,
      73,    31,    32,    33,    34,    35,    36,    37,    38,    41,
      41,    41,    41,    73,    59,    74,    74,    75,    75,    75,
      73,    73,    48,    80,    41,    45,    73,    73,    73,    73,
      73,    73,    73,    73,    42,    45,    43,    45,    73,    23,
      59,    12,    67,    63,    80,    73,    43,    42,    59,    43
};

  /* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    51,    52,    53,    53,    54,    55,    56,    56,    57,
      57,    58,    59,    59,    60,    60,    60,    60,    60,    60,
      60,    60,    60,    60,    60,    60,    61,    62,    63,    63,
      64,    65,    66,    67,    67,    68,    69,    70,    71,    71,
      71,    71,    71,    71,    72,    72,    72,    72,    72,    72,
      72,    72,    72,    73,    73,    73,    74,    74,    74,    74,
      75,    76,    77,    78,    79,    79,    80,    80,    81
};

  /* YYR2[YYN] -- Number of symbols on the right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     0,     2,     8,     1,     0,     2,     0,
       3,     2,     0,     2,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     3,     6,     0,     2,
       4,     4,     6,     0,     4,     7,     1,     1,     1,     1,
       3,     1,     1,     4,     1,     3,     3,     3,     3,     3,
       3,     3,     3,     1,     3,     3,     1,     3,     3,     3,
       1,     3,     6,     4,     0,     2,     0,     3,     2
};


#define yyerrok         (yyerrstatus = 0)
#define yyclearin       (yychar = YYEMPTY)
#define YYEMPTY         (-2)
#define YYEOF           0

#define YYACCEPT        goto yyacceptlab
#define YYABORT         goto yyabortlab
#define YYERROR         goto yyerrorlab


#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)                                  \
do                                                              \
  if (yychar == YYEMPTY)                                        \
    {                                                           \
      yychar = (Token);                                         \
      yylval = (Value);                                         \
      YYPOPSTACK (yylen);                                       \
      yystate = *yyssp;                                         \
      goto yybackup;                                            \
    }                                                           \
  else                                                          \
    {                                                           \
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;                                                  \
    }                                                           \
while (0)

/* Error token number */
#define YYTERROR        1
#define YYERRCODE       256



/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)                        \
do {                                            \
  if (yydebug)                                  \
    YYFPRINTF Args;                             \
} while (0)

/* This macro is provided for backward compatibility. */
#ifndef YY_LOCATION_PRINT
# define YY_LOCATION_PRINT(File, Loc) ((void) 0)
#endif


# define YY_SYMBOL_PRINT(Title, Type, Value, Location)                    \
do {                                                                      \
  if (yydebug)                                                            \
    {                                                                     \
      YYFPRINTF (stderr, "%s ", Title);                                   \
      yy_symbol_print (stderr,                                            \
                  Type, Value); \
      YYFPRINTF (stderr, "\n");                                           \
    }                                                                     \
} while (0)


/*----------------------------------------.
| Print this symbol's value on YYOUTPUT.  |
`----------------------------------------*/

static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  FILE *yyo = yyoutput;
  YYUSE (yyo);
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
  YYUSE (yytype);
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
{
  YYFPRINTF (yyoutput, "%s %s (",
             yytype < YYNTOKENS ? "token" : "nterm", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

static void
yy_stack_print (yytype_int16 *yybottom, yytype_int16 *yytop)
{
  YYFPRINTF (stderr, "Stack now");
  for (; yybottom <= yytop; yybottom++)
    {
      int yybot = *yybottom;
      YYFPRINTF (stderr, " %d", yybot);
    }
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)                            \
do {                                                            \
  if (yydebug)                                                  \
    yy_stack_print ((Bottom), (Top));                           \
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

static void
yy_reduce_print (yytype_int16 *yyssp, YYSTYPE *yyvsp, int yyrule)
{
  unsigned long int yylno = yyrline[yyrule];
  int yynrhs = yyr2[yyrule];
  int yyi;
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
             yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      YYFPRINTF (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr,
                       yystos[yyssp[yyi + 1 - yynrhs]],
                       &(yyvsp[(yyi + 1) - (yynrhs)])
                                              );
      YYFPRINTF (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)          \
do {                                    \
  if (yydebug)                          \
    yy_reduce_print (yyssp, yyvsp, Rule); \
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif


#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
yystrlen (const char *yystr)
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
yystpcpy (char *yydest, const char *yysrc)
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
        switch (*++yyp)
          {
          case '\'':
          case ',':
            goto do_not_strip_quotes;

          case '\\':
            if (*++yyp != '\\')
              goto do_not_strip_quotes;
            /* Fall through.  */
          default:
            if (yyres)
              yyres[yyn] = *yyp;
            yyn++;
            break;

          case '"':
            if (yyres)
              yyres[yyn] = '\0';
            return yyn;
          }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into *YYMSG, which is of size *YYMSG_ALLOC, an error message
   about the unexpected token YYTOKEN for the state stack whose top is
   YYSSP.

   Return 0 if *YYMSG was successfully written.  Return 1 if *YYMSG is
   not large enough to hold the message.  In that case, also set
   *YYMSG_ALLOC to the required number of bytes.  Return 2 if the
   required number of bytes is too large to store.  */
static int
yysyntax_error (YYSIZE_T *yymsg_alloc, char **yymsg,
                yytype_int16 *yyssp, int yytoken)
{
  YYSIZE_T yysize0 = yytnamerr (YY_NULLPTR, yytname[yytoken]);
  YYSIZE_T yysize = yysize0;
  enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
  /* Internationalized format string. */
  const char *yyformat = YY_NULLPTR;
  /* Arguments of yyformat. */
  char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
  /* Number of reported tokens (one for the "unexpected", one per
     "expected"). */
  int yycount = 0;

  /* There are many possibilities here to consider:
     - If this state is a consistent state with a default action, then
       the only way this function was invoked is if the default action
       is an error action.  In that case, don't check for expected
       tokens because there are none.
     - The only way there can be no lookahead present (in yychar) is if
       this state is a consistent state with a default action.  Thus,
       detecting the absence of a lookahead is sufficient to determine
       that there is no unexpected or expected token to report.  In that
       case, just report a simple "syntax error".
     - Don't assume there isn't a lookahead just because this state is a
       consistent state with a default action.  There might have been a
       previous inconsistent state, consistent state with a non-default
       action, or user semantic action that manipulated yychar.
     - Of course, the expected token list depends on states to have
       correct lookahead information, and it depends on the parser not
       to perform extra reductions after fetching a lookahead from the
       scanner and before detecting a syntax error.  Thus, state merging
       (from LALR or IELR) and default reductions corrupt the expected
       token list.  However, the list is correct for canonical LR with
       one exception: it will still contain any token that will not be
       accepted due to an error action in a later state.
  */
  if (yytoken != YYEMPTY)
    {
      int yyn = yypact[*yyssp];
      yyarg[yycount++] = yytname[yytoken];
      if (!yypact_value_is_default (yyn))
        {
          /* Start YYX at -YYN if negative to avoid negative indexes in
             YYCHECK.  In other words, skip the first -YYN actions for
             this state because they are default actions.  */
          int yyxbegin = yyn < 0 ? -yyn : 0;
          /* Stay within bounds of both yycheck and yytname.  */
          int yychecklim = YYLAST - yyn + 1;
          int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
          int yyx;

          for (yyx = yyxbegin; yyx < yyxend; ++yyx)
            if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR
                && !yytable_value_is_error (yytable[yyx + yyn]))
              {
                if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
                  {
                    yycount = 1;
                    yysize = yysize0;
                    break;
                  }
                yyarg[yycount++] = yytname[yyx];
                {
                  YYSIZE_T yysize1 = yysize + yytnamerr (YY_NULLPTR, yytname[yyx]);
                  if (! (yysize <= yysize1
                         && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
                    return 2;
                  yysize = yysize1;
                }
              }
        }
    }

  switch (yycount)
    {
# define YYCASE_(N, S)                      \
      case N:                               \
        yyformat = S;                       \
      break
      YYCASE_(0, YY_("syntax error"));
      YYCASE_(1, YY_("syntax error, unexpected %s"));
      YYCASE_(2, YY_("syntax error, unexpected %s, expecting %s"));
      YYCASE_(3, YY_("syntax error, unexpected %s, expecting %s or %s"));
      YYCASE_(4, YY_("syntax error, unexpected %s, expecting %s or %s or %s"));
      YYCASE_(5, YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s"));
# undef YYCASE_
    }

  {
    YYSIZE_T yysize1 = yysize + yystrlen (yyformat);
    if (! (yysize <= yysize1 && yysize1 <= YYSTACK_ALLOC_MAXIMUM))
      return 2;
    yysize = yysize1;
  }

  if (*yymsg_alloc < yysize)
    {
      *yymsg_alloc = 2 * yysize;
      if (! (yysize <= *yymsg_alloc
             && *yymsg_alloc <= YYSTACK_ALLOC_MAXIMUM))
        *yymsg_alloc = YYSTACK_ALLOC_MAXIMUM;
      return 1;
    }

  /* Avoid sprintf, as that infringes on the user's name space.
     Don't have undefined behavior even if the translation
     produced a string with the wrong number of "%s"s.  */
  {
    char *yyp = *yymsg;
    int yyi = 0;
    while ((*yyp = *yyformat) != '\0')
      if (*yyp == '%' && yyformat[1] == 's' && yyi < yycount)
        {
          yyp += yytnamerr (yyp, yyarg[yyi++]);
          yyformat += 2;
        }
      else
        {
          yyp++;
          yyformat++;
        }
  }
  return 0;
}
#endif /* YYERROR_VERBOSE */

/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
{
  YYUSE (yyvaluep);
  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  YYUSE (yytype);
  YY_IGNORE_MAYBE_UNINITIALIZED_END
}




/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;
/* Number of syntax errors so far.  */
int yynerrs;


/*----------.
| yyparse.  |
`----------*/

int
yyparse (void)
{
    int yystate;
    /* Number of tokens to shift before error messages enabled.  */
    int yyerrstatus;

    /* The stacks and their tools:
       'yyss': related to states.
       'yyvs': related to semantic values.

       Refer to the stacks through separate pointers, to allow yyoverflow
       to reallocate them elsewhere.  */

    /* The state stack.  */
    yytype_int16 yyssa[YYINITDEPTH];
    yytype_int16 *yyss;
    yytype_int16 *yyssp;

    /* The semantic value stack.  */
    YYSTYPE yyvsa[YYINITDEPTH];
    YYSTYPE *yyvs;
    YYSTYPE *yyvsp;

    YYSIZE_T yystacksize;

  int yyn;
  int yyresult;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;
  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;

#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  yyssp = yyss = yyssa;
  yyvsp = yyvs = yyvsa;
  yystacksize = YYINITDEPTH;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY; /* Cause a token to be read.  */
  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
        /* Give user a chance to reallocate the stack.  Use copies of
           these so that the &'s don't force the real ones into
           memory.  */
        YYSTYPE *yyvs1 = yyvs;
        yytype_int16 *yyss1 = yyss;

        /* Each stack pointer address is followed by the size of the
           data in use in that stack, in bytes.  This used to be a
           conditional around just the two extra args, but that might
           be undefined if yyoverflow is a macro.  */
        yyoverflow (YY_("memory exhausted"),
                    &yyss1, yysize * sizeof (*yyssp),
                    &yyvs1, yysize * sizeof (*yyvsp),
                    &yystacksize);

        yyss = yyss1;
        yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
        goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
        yystacksize = YYMAXDEPTH;

      {
        yytype_int16 *yyss1 = yyss;
        union yyalloc *yyptr =
          (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
        if (! yyptr)
          goto yyexhaustedlab;
        YYSTACK_RELOCATE (yyss_alloc, yyss);
        YYSTACK_RELOCATE (yyvs_alloc, yyvs);
#  undef YYSTACK_RELOCATE
        if (yyss1 != yyssa)
          YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;

      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
                  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
        YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  if (yystate == YYFINAL)
    YYACCEPT;

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     lookahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to lookahead token.  */
  yyn = yypact[yystate];
  if (yypact_value_is_default (yyn))
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = yylex ();
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yytable_value_is_error (yyn))
        goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the lookahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token.  */
  yychar = YYEMPTY;

  yystate = yyn;
  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     '$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 164 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *node = (yyvsp[0].node);
                        std::string code = node->code;
                        printf("Generated code:\n");
                        printf("%s\n", code.c_str());
                }
#line 1471 "y.tab.c" /* yacc.c:1646  */
    break;

  case 3:
#line 172 "compiler.y" /* yacc.c:1646  */
    {
                CodeNode *node = new CodeNode;
                (yyval.node) = node;
        }
#line 1480 "y.tab.c" /* yacc.c:1646  */
    break;

  case 4:
#line 176 "compiler.y" /* yacc.c:1646  */
    {
                CodeNode *func = (yyvsp[-1].node);
                CodeNode *funcs = (yyvsp[0].node);
                std::string code = func->code + std::string("\n") + funcs->code;

                CodeNode *node = new CodeNode;
                node->code = code;
                (yyval.node) = node;
        }
#line 1494 "y.tab.c" /* yacc.c:1646  */
    break;

  case 5:
#line 189 "compiler.y" /* yacc.c:1646  */
    {
                        std::string func_name = (yyvsp[-6].op_val);
                        CodeNode *args = (yyvsp[-4].node);
                        CodeNode *stmts = (yyvsp[-1].node);

                        std::string code = std::string("func ") + func_name + std::string("\n");
                        code += args->code;
                        code += stmts->code;
                        code += std::string("endfunc\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        (yyval.node) = node;
                }
#line 1513 "y.tab.c" /* yacc.c:1646  */
    break;

  case 6:
#line 206 "compiler.y" /* yacc.c:1646  */
    {
                        std::string name = (yyvsp[0].op_val);
                        add_function_to_symbol_table(name);
                        (yyval.op_val) = (yyvsp[0].op_val);
                }
#line 1523 "y.tab.c" /* yacc.c:1646  */
    break;

  case 7:
#line 214 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *node = new CodeNode;
                        (yyval.node) = node;
                }
#line 1532 "y.tab.c" /* yacc.c:1646  */
    break;

  case 8:
#line 219 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *arg = (yyvsp[-1].node);
                        CodeNode *args = (yyvsp[0].node);

                        std::string varAssign = "";
                        std::string code = arg->code + args->code;
                        
                        std::stringstream ss(code);
                        std::ostringstream intConvert;
                        std::string currLine;
                        int currPar = 0;

                        while (std::getline(ss, currLine)) {
                                std::string currVar;
                                
                                if (currLine.substr(0, 2) == ". ") {
                                        currVar = currLine.substr(2);
                                }
                                intConvert << currPar++;
                                varAssign += "= " + currVar + ", " + "$" + intConvert.str() + "\n";
                                intConvert.str("");
                                intConvert.clear();
                        }

                        CodeNode *node = new CodeNode;
                        node->code = code + varAssign;
                        (yyval.node) = node;
                }
#line 1565 "y.tab.c" /* yacc.c:1646  */
    break;

  case 9:
#line 250 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *node = new CodeNode;
                        (yyval.node) = node;                        
                }
#line 1574 "y.tab.c" /* yacc.c:1646  */
    break;

  case 10:
#line 255 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *arg = (yyvsp[-1].node);
                        CodeNode *args = (yyvsp[0].node);
                        std::string code = arg->code + args->code;

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        (yyval.node) = node;
                }
#line 1588 "y.tab.c" /* yacc.c:1646  */
    break;

  case 11:
#line 267 "compiler.y" /* yacc.c:1646  */
    {
                        std::string value = (yyvsp[0].op_val);
                        Type t = Integer;
                        add_variable_to_symbol_table(value, t);

                        std::string code = std::string(". ") + value + std::string("\n");
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        (yyval.node) = node;
                }
#line 1604 "y.tab.c" /* yacc.c:1646  */
    break;

  case 12:
#line 282 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *node = new CodeNode;
                        (yyval.node) = node;                        
                }
#line 1613 "y.tab.c" /* yacc.c:1646  */
    break;

  case 13:
#line 287 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *stmt = (yyvsp[-1].node);
                        CodeNode *stmts = (yyvsp[0].node);
                        
                        CodeNode *node = new CodeNode;
                        node->code = stmt->code + stmts->code;
                        (yyval.node) = node;
                }
#line 1626 "y.tab.c" /* yacc.c:1646  */
    break;

  case 14:
#line 299 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *varDec = (yyvsp[0].node);

                        CodeNode *node = new CodeNode;
                        node->code = varDec->code;
                        (yyval.node) = node;
                }
#line 1638 "y.tab.c" /* yacc.c:1646  */
    break;

  case 15:
#line 307 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *arrDec = (yyvsp[0].node);

                        CodeNode *node = new CodeNode;
                        node->code = arrDec->code;
                        (yyval.node) = node;
                }
#line 1650 "y.tab.c" /* yacc.c:1646  */
    break;

  case 16:
#line 315 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *print = (yyvsp[0].node);

                        CodeNode *node = new CodeNode;
                        node->code = print->code;
                        (yyval.node) = node;
                }
#line 1662 "y.tab.c" /* yacc.c:1646  */
    break;

  case 17:
#line 323 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *input = (yyvsp[0].node);

                        CodeNode *node = new CodeNode;
                        node->code = input->code;
                        (yyval.node) = node;
                }
#line 1674 "y.tab.c" /* yacc.c:1646  */
    break;

  case 18:
#line 331 "compiler.y" /* yacc.c:1646  */
    {

                }
#line 1682 "y.tab.c" /* yacc.c:1646  */
    break;

  case 19:
#line 335 "compiler.y" /* yacc.c:1646  */
    {
                        
                }
#line 1690 "y.tab.c" /* yacc.c:1646  */
    break;

  case 20:
#line 339 "compiler.y" /* yacc.c:1646  */
    {
                        
                }
#line 1698 "y.tab.c" /* yacc.c:1646  */
    break;

  case 21:
#line 343 "compiler.y" /* yacc.c:1646  */
    {
                        
                }
#line 1706 "y.tab.c" /* yacc.c:1646  */
    break;

  case 22:
#line 347 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *funcCall = (yyvsp[0].node);
			if (!find(funcCall->name)) {
				yyerror("The function has not been defined.");
			}

                        CodeNode *node = new CodeNode;
                        node->code = funcCall->code;
                        (yyval.node) = node;
                }
#line 1721 "y.tab.c" /* yacc.c:1646  */
    break;

  case 23:
#line 358 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *returnStmt = (yyvsp[0].node);
                        
                        CodeNode *node = new CodeNode;
                        node->code = returnStmt->code;
                        (yyval.node) = node;
                }
#line 1733 "y.tab.c" /* yacc.c:1646  */
    break;

  case 24:
#line 366 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *assignVar = (yyvsp[0].node);
                        
                        CodeNode *node = new CodeNode;
                        node->code = assignVar->code;
                        (yyval.node) = node;
                }
#line 1745 "y.tab.c" /* yacc.c:1646  */
    break;

  case 25:
#line 374 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *assignArr = (yyvsp[0].node);
                        
                        CodeNode *node = new CodeNode;
                        node->code = assignArr->code;
                        (yyval.node) = node;
                }
#line 1757 "y.tab.c" /* yacc.c:1646  */
    break;

  case 26:
#line 385 "compiler.y" /* yacc.c:1646  */
    {
                        std::string ident = (yyvsp[-1].op_val);
                        CodeNode *assignState = (yyvsp[0].node);
                        Type t = Integer;
			if(find(ident)) {
				yyerror("This variable is already defined.");
			}
                        add_variable_to_symbol_table(ident, t);

                        std::string code = std::string(". ") + ident + std::string("\n");
                        if (assignState->code != "") {
                                code += std::string("= ") + ident + std::string(", ") + assignState->code;
                        }
                        
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        
                        (yyval.node) = node;
                }
#line 1781 "y.tab.c" /* yacc.c:1646  */
    break;

  case 27:
#line 408 "compiler.y" /* yacc.c:1646  */
    {
                        std::string ident = (yyvsp[-4].op_val);
                        CodeNode *addexp = (yyvsp[-2].node);
                        CodeNode *assignState = (yyvsp[0].node);
                        Type t = Array;
                        add_variable_to_symbol_table(ident, t);

                        std::string code = std::string(".[] ") + ident + std::string(", ") + addexp->name + std::string("\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        (yyval.node) = node;
                }
#line 1799 "y.tab.c" /* yacc.c:1646  */
    break;

  case 28:
#line 424 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *node = new CodeNode;
                        (yyval.node) = node;                        
                }
#line 1808 "y.tab.c" /* yacc.c:1646  */
    break;

  case 29:
#line 429 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *addexp = (yyvsp[0].node);

                        std::string code = addexp->name + std::string("\n");

                        CodeNode *node = new CodeNode;
                        node->code = code;
                        (yyval.node) = node;
                }
#line 1822 "y.tab.c" /* yacc.c:1646  */
    break;

  case 30:
#line 441 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *binexp = (yyvsp[-1].node);
                        std::string code = binexp->code + std::string(".> ") + binexp->name + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        (yyval.node) = node;
                }
#line 1834 "y.tab.c" /* yacc.c:1646  */
    break;

  case 31:
#line 451 "compiler.y" /* yacc.c:1646  */
    {
                        std::string value = (yyvsp[-1].op_val);
                        std::string code = std::string(".< ") + value + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = value;
                        (yyval.node) = node;
                }
#line 1847 "y.tab.c" /* yacc.c:1646  */
    break;

  case 32:
#line 462 "compiler.y" /* yacc.c:1646  */
    {
                }
#line 1854 "y.tab.c" /* yacc.c:1646  */
    break;

  case 33:
#line 467 "compiler.y" /* yacc.c:1646  */
    {
                }
#line 1861 "y.tab.c" /* yacc.c:1646  */
    break;

  case 34:
#line 470 "compiler.y" /* yacc.c:1646  */
    {
                }
#line 1868 "y.tab.c" /* yacc.c:1646  */
    break;

  case 35:
#line 476 "compiler.y" /* yacc.c:1646  */
    {
                }
#line 1875 "y.tab.c" /* yacc.c:1646  */
    break;

  case 36:
#line 481 "compiler.y" /* yacc.c:1646  */
    {
                }
#line 1882 "y.tab.c" /* yacc.c:1646  */
    break;

  case 37:
#line 486 "compiler.y" /* yacc.c:1646  */
    {
                }
#line 1889 "y.tab.c" /* yacc.c:1646  */
    break;

  case 38:
#line 491 "compiler.y" /* yacc.c:1646  */
    {
			std::string i = (yyvsp[0].op_val);
                	if(!find(i)) {
                		yyerror("variables used, previously not defined");
                	}
			if(find(i, Array)) {
				yyerror("Regular variable used as array.");
			}
                        CodeNode *node = new CodeNode;
                        node->name = i;
                        (yyval.node) = node;

                }
#line 1907 "y.tab.c" /* yacc.c:1646  */
    break;

  case 39:
#line 505 "compiler.y" /* yacc.c:1646  */
    {
                        std::string value = (yyvsp[0].op_val);
                        CodeNode *node = new CodeNode;
                        node->name = value;
                        (yyval.node) = node;
                }
#line 1918 "y.tab.c" /* yacc.c:1646  */
    break;

  case 40:
#line 512 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *binexp = (yyvsp[-1].node);
                        CodeNode *node = new CodeNode;
                        node->code = binexp->code;
                        node->name = binexp->name;
                        (yyval.node) = node;
                }
#line 1930 "y.tab.c" /* yacc.c:1646  */
    break;

  case 41:
#line 521 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *inState = (yyvsp[0].node);
                        CodeNode *node = new CodeNode;
                        node->code = inState->code;
                        node->name = inState->name;
                        (yyval.node) = node;
                }
#line 1942 "y.tab.c" /* yacc.c:1646  */
    break;

  case 42:
#line 529 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *func = (yyvsp[0].node);
                        CodeNode *node = new CodeNode;
                        node->code = func->code;
                        node->name = func->name;
                        (yyval.node) = node;
                }
#line 1954 "y.tab.c" /* yacc.c:1646  */
    break;

  case 43:
#line 537 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();
                        std::string ident = (yyvsp[-3].op_val);
			if(!find(ident)) {
				yyerror("Array not defined.");
			}
			else if(find(ident, Integer)) {
				yyerror("Brackets don't apply to Integer variables.");			
			}
                        CodeNode *addexp = (yyvsp[-1].node);
                        std::string code = decl_temp(temp) + std::string ("=[] ") + temp + std::string(", ") + ident + std::string(", ") + addexp->name + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 1975 "y.tab.c" /* yacc.c:1646  */
    break;

  case 44:
#line 556 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *addexp = (yyvsp[0].node);
                        CodeNode *node = new CodeNode;
                        node->code = addexp->code;
                        node->name = addexp->name;
                        (yyval.node) = node;
                }
#line 1987 "y.tab.c" /* yacc.c:1646  */
    break;

  case 45:
#line 564 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = (yyvsp[-2].node)->code + (yyvsp[0].node)->code + decl_temp(temp);
                        node->code += std::string("== ") + temp + std::string(", ") + (yyvsp[-2].node)->name + std::string(", ") + (yyvsp[0].node)->name + std::string("\n");
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2000 "y.tab.c" /* yacc.c:1646  */
    break;

  case 46:
#line 573 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = (yyvsp[-2].node)->code + (yyvsp[0].node)->code + decl_temp(temp);
                        node->code += std::string("!= ") + temp + std::string(", ") + (yyvsp[-2].node)->name + std::string(", ") + (yyvsp[0].node)->name + std::string("\n");
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2013 "y.tab.c" /* yacc.c:1646  */
    break;

  case 47:
#line 582 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = (yyvsp[-2].node)->code + (yyvsp[0].node)->code + decl_temp(temp);
                        node->code += std::string("< ") + temp + std::string(", ") + (yyvsp[-2].node)->name + std::string(", ") + (yyvsp[0].node)->name + std::string("\n");
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2026 "y.tab.c" /* yacc.c:1646  */
    break;

  case 48:
#line 591 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();

                        CodeNode *node = new CodeNode;
                        node->code = (yyvsp[-2].node)->code + (yyvsp[0].node)->code + decl_temp(temp);
                        node->code += std::string("<= ") + temp + std::string(", ") + (yyvsp[-2].node)->name + std::string(", ") + (yyvsp[0].node)->name + std::string("\n");
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2040 "y.tab.c" /* yacc.c:1646  */
    break;

  case 49:
#line 601 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = (yyvsp[-2].node)->code + (yyvsp[0].node)->code + decl_temp(temp);
                        node->code += std::string("> ") + temp + std::string(", ") + (yyvsp[-2].node)->name + std::string(", ") + (yyvsp[0].node)->name + std::string("\n");
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2053 "y.tab.c" /* yacc.c:1646  */
    break;

  case 50:
#line 610 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = (yyvsp[-2].node)->code + (yyvsp[0].node)->code + decl_temp(temp);
                        node->code += std::string(">= ") + temp + std::string(", ") + (yyvsp[-2].node)->name + std::string(", ") + (yyvsp[0].node)->name + std::string("\n");
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2066 "y.tab.c" /* yacc.c:1646  */
    break;

  case 51:
#line 619 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();

                        CodeNode *node = new CodeNode;
                        node->code = (yyvsp[-2].node)->code + (yyvsp[0].node)->code + decl_temp(temp);
                        node->code += std::string("&& ") + temp + std::string(", ") + (yyvsp[-2].node)->name + std::string(", ") + (yyvsp[0].node)->name + std::string("\n");
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2080 "y.tab.c" /* yacc.c:1646  */
    break;

  case 52:
#line 629 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = (yyvsp[-2].node)->code + (yyvsp[0].node)->code + decl_temp(temp);
                        node->code += std::string("|| ") + temp + std::string(", ") + (yyvsp[-2].node)->name + std::string(", ") + (yyvsp[0].node)->name + std::string("\n");
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2093 "y.tab.c" /* yacc.c:1646  */
    break;

  case 53:
#line 641 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *multexp = (yyvsp[0].node);
                        CodeNode *node = new CodeNode;
                        node->code = multexp->code;
                        node->name = multexp->name;
                        (yyval.node) = node;
                }
#line 2105 "y.tab.c" /* yacc.c:1646  */
    break;

  case 54:
#line 649 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = (yyvsp[-2].node)->code + (yyvsp[0].node)->code;
                        node->code += decl_temp(temp) + std::string("+ ") + temp + std::string(", ") + (yyvsp[-2].node)->name + std::string(", ") + (yyvsp[0].node)->name + std::string("\n");
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2118 "y.tab.c" /* yacc.c:1646  */
    break;

  case 55:
#line 658 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = (yyvsp[-2].node)->code + (yyvsp[0].node)->code;
                        node->code += decl_temp(temp) + std::string("- ") + temp + std::string(", ") + (yyvsp[-2].node)->name + std::string(", ") + (yyvsp[0].node)->name + std::string("\n");
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2131 "y.tab.c" /* yacc.c:1646  */
    break;

  case 56:
#line 670 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *baseexp = (yyvsp[0].node);
                        CodeNode *node = new CodeNode;
                        node->code = baseexp->code;
                        node->name = baseexp->name;
                        (yyval.node) = node;
                }
#line 2143 "y.tab.c" /* yacc.c:1646  */
    break;

  case 57:
#line 678 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = (yyvsp[-2].node)->code + (yyvsp[0].node)->code;
                        node->code += decl_temp(temp) + std::string("* ") + temp + std::string(", ") + (yyvsp[-2].node)->name + std::string(", ") + (yyvsp[0].node)->name + std::string("\n");
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2156 "y.tab.c" /* yacc.c:1646  */
    break;

  case 58:
#line 687 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = (yyvsp[-2].node)->code + (yyvsp[0].node)->code;
                        node->code += decl_temp(temp) + std::string("/ ") + temp + std::string(", ") + (yyvsp[-2].node)->name + std::string(", ") + (yyvsp[0].node)->name + std::string("\n");
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2169 "y.tab.c" /* yacc.c:1646  */
    break;

  case 59:
#line 696 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();
                        CodeNode *node = new CodeNode;
                        node->code = (yyvsp[-2].node)->code + (yyvsp[0].node)->code;
                        node->code += decl_temp(temp) + std::string("% ") + temp + std::string(", ") + (yyvsp[-2].node)->name + std::string(", ") + (yyvsp[0].node)->name + std::string("\n");
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2182 "y.tab.c" /* yacc.c:1646  */
    break;

  case 60:
#line 708 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *exp = (yyvsp[0].node);
                        CodeNode *node = new CodeNode;
                        node->code = exp->code;
                        node->name = exp->name;
                        (yyval.node) = node;
                }
#line 2194 "y.tab.c" /* yacc.c:1646  */
    break;

  case 61:
#line 718 "compiler.y" /* yacc.c:1646  */
    {
                        std::string ident = (yyvsp[-2].op_val);
                        CodeNode *addexp = (yyvsp[0].node);
                        if(!find(ident)) {
                        	yyerror("used variable was not previously declared.");
                        }
                        std::string code = addexp->code + std::string("= ") + ident + std::string(", ") + addexp->name + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        (yyval.node) = node;
                }
#line 2210 "y.tab.c" /* yacc.c:1646  */
    break;

  case 62:
#line 732 "compiler.y" /* yacc.c:1646  */
    {
                        std::string ident = (yyvsp[-5].op_val);
                        CodeNode *index = (yyvsp[-3].node);
                        CodeNode *addexp = (yyvsp[0].node);
                        std::string code = index->code + addexp->code + std::string("[]= ") + ident + std::string(", ") + index->name + std::string(", ") + addexp->name + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        (yyval.node) = node;
                }
#line 2224 "y.tab.c" /* yacc.c:1646  */
    break;

  case 63:
#line 744 "compiler.y" /* yacc.c:1646  */
    {
                        std::string temp = create_temp();
                        std::string ident = (yyvsp[-3].op_val);
                        CodeNode *param = (yyvsp[-1].node);
                        std::string code = param->code + decl_temp(temp);
                        code += std::string("call ") + ident + std::string(", ") + temp + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        node->name = temp;
                        (yyval.node) = node;
                }
#line 2240 "y.tab.c" /* yacc.c:1646  */
    break;

  case 64:
#line 758 "compiler.y" /* yacc.c:1646  */
    {
                       CodeNode *node = new CodeNode;
                       (yyval.node) = node;       
                }
#line 2249 "y.tab.c" /* yacc.c:1646  */
    break;

  case 65:
#line 763 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *addexp = (yyvsp[-1].node);
                        CodeNode *params = (yyvsp[0].node);
                        std::string code = std::string("param ") + addexp->name + std::string("\n");
                        code += params->code;
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        (yyval.node) = node;
                }
#line 2263 "y.tab.c" /* yacc.c:1646  */
    break;

  case 66:
#line 775 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *node = new CodeNode;
                        (yyval.node) = node;  
                }
#line 2272 "y.tab.c" /* yacc.c:1646  */
    break;

  case 67:
#line 780 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *addexp = (yyvsp[-1].node);
                        std::string code = addexp->code;
                        code += std::string("param ") + addexp->name + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        (yyval.node) = node;
                }
#line 2285 "y.tab.c" /* yacc.c:1646  */
    break;

  case 68:
#line 791 "compiler.y" /* yacc.c:1646  */
    {
                        CodeNode *ret = (yyvsp[0].node);
                        std::string code = ret->code + std::string("ret ") + ret->name + std::string("\n");
                        CodeNode *node = new CodeNode;
                        node->code = code;
                        (yyval.node) = node;
                }
#line 2297 "y.tab.c" /* yacc.c:1646  */
    break;


#line 2301 "y.tab.c" /* yacc.c:1646  */
      default: break;
    }
  /* User semantic actions sometimes alter yychar, and that requires
     that yytoken be updated with the new translation.  We take the
     approach of translating immediately before every use of yytoken.
     One alternative is translating here after every semantic action,
     but that translation would be missed if the semantic action invokes
     YYABORT, YYACCEPT, or YYERROR immediately after altering yychar or
     if it invokes YYBACKUP.  In the case of YYABORT or YYACCEPT, an
     incorrect destructor might then be invoked immediately.  In the
     case of YYERROR or YYBACKUP, subsequent parser actions might lead
     to an incorrect destructor call or verbose syntax error message
     before the lookahead is translated.  */
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;

  /* Now 'shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*--------------------------------------.
| yyerrlab -- here on detecting error.  |
`--------------------------------------*/
yyerrlab:
  /* Make sure we have latest lookahead translation.  See comments at
     user semantic actions for why this is necessary.  */
  yytoken = yychar == YYEMPTY ? YYEMPTY : YYTRANSLATE (yychar);

  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
# define YYSYNTAX_ERROR yysyntax_error (&yymsg_alloc, &yymsg, \
                                        yyssp, yytoken)
      {
        char const *yymsgp = YY_("syntax error");
        int yysyntax_error_status;
        yysyntax_error_status = YYSYNTAX_ERROR;
        if (yysyntax_error_status == 0)
          yymsgp = yymsg;
        else if (yysyntax_error_status == 1)
          {
            if (yymsg != yymsgbuf)
              YYSTACK_FREE (yymsg);
            yymsg = (char *) YYSTACK_ALLOC (yymsg_alloc);
            if (!yymsg)
              {
                yymsg = yymsgbuf;
                yymsg_alloc = sizeof yymsgbuf;
                yysyntax_error_status = 2;
              }
            else
              {
                yysyntax_error_status = YYSYNTAX_ERROR;
                yymsgp = yymsg;
              }
          }
        yyerror (yymsgp);
        if (yysyntax_error_status == 2)
          goto yyexhaustedlab;
      }
# undef YYSYNTAX_ERROR
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
         error, discard it.  */

      if (yychar <= YYEOF)
        {
          /* Return failure if at end of input.  */
          if (yychar == YYEOF)
            YYABORT;
        }
      else
        {
          yydestruct ("Error: discarding",
                      yytoken, &yylval);
          yychar = YYEMPTY;
        }
    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule whose action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;      /* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (!yypact_value_is_default (yyn))
        {
          yyn += YYTERROR;
          if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
            {
              yyn = yytable[yyn];
              if (0 < yyn)
                break;
            }
        }

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
        YYABORT;


      yydestruct ("Error: popping",
                  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  YY_IGNORE_MAYBE_UNINITIALIZED_BEGIN
  *++yyvsp = yylval;
  YY_IGNORE_MAYBE_UNINITIALIZED_END


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#if !defined yyoverflow || YYERROR_VERBOSE
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEMPTY)
    {
      /* Make sure we have latest lookahead translation.  See comments at
         user semantic actions for why this is necessary.  */
      yytoken = YYTRANSLATE (yychar);
      yydestruct ("Cleanup: discarding lookahead",
                  yytoken, &yylval);
    }
  /* Do not reclaim the symbols of the rule whose action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
                  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  return yyresult;
}
#line 798 "compiler.y" /* yacc.c:1906  */

void yyerror(const char* s) {
	fprintf(stderr, "Error %s at line %d, column %d\n", s, yylineno, curr_col);
} 
int main(int argc, char** argv) {
	if (argc >= 2) {
		yyin = fopen(argv[1], "r");
		if (yyin == NULL)
			yyin = stdin;
	}
	else {
		yyin = stdin;
	}
	yyparse();
	std::string main = "main";
        if (!find(main)) {
		yyerror("main not defined.\n");
	}
}
