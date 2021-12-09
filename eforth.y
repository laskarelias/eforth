%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "stack.h"
#define YYDEBUG 1

#define KNRM  "\x1B[0m"
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"

extern int yylineno;
extern int yylex();
extern int yyparse();
extern void yyrestart(FILE* f);
extern FILE* yyin;

extern void yyerror(const char *s);

extern t_stack* stack;
extern t_stack* statics;
extern int error;

void stack_underflow() {
    printf(KRED " stack underflow" KNRM "\n> ");
    yyrestart(yyin);
}

%}

%union {
    int   no;
    char  sym;
    char  str[32];
}

%token <no>  NUMBER;
%token <sym> MATH;
%token       DOT;
%token       EMIT;

%token       DROP;
%token       SWAP;
%token       OVER;
%token       ROT;

%token       BYE;
%token       FORGOT;
%token       CLEAR;
%token <str> WORD;
%token       ENTER;

%%

lines: lines line
     | line
     ;

line: words ENTER {
          printf(error ? "" : " ok "); 
          print(stack);
          error = 0;
          printf("> ");
      }
    ;

words: words word
     | word
     ;

word: NUMBER { 
          push(stack, number, $1);
      }
    | MATH { 
          t_item a = pop(stack);
          t_item b = pop(stack);
          if (a.type != invalid && b.type != invalid) {
              switch ($1) {
                  case '+':
                      push(stack, number, b.value + a.value);
                      break;
                  case '-':
                      push(stack, number, b.value - a.value);
                      break;
                  case '*':
                      push(stack, number, b.value * a.value);
                      break;
                  case '/':
                      push(stack, number, b.value / a.value);
                      break;
                  default:
                      push(stack, number, 0);
                      break;
              }
          } else { stack_underflow(); }
      }
    | DOT {
          t_item a = pop(stack);
          a.type == invalid ? stack_underflow() : printf("%c", a.value);
      }
    | EMIT {
          t_item a = pop(stack);
          a.type == invalid ? stack_underflow() : printf("%c", a.value);
      }
    | DROP {
          t_item a = pop(stack);
          if (a.type == invalid) { stack_underflow(); }
      }
    | SWAP {
          t_item a = pop(stack);
          t_item b = pop(stack);
          if (a.type != invalid && b.type != invalid) {
              push(stack, a.type, a.value);
              push(stack, b.type, b.value);
          } else { stack_underflow(); }
      }

    | OVER {
          t_item a = pop(stack);
          t_item b = pop(stack);
          if (a.type != invalid && b.type != invalid) {
              push(stack, b.type, b.value);
              push(stack, a.type, a.value);
              push(stack, b.type, b.value);
          } else { stack_underflow(); } 
      }
    | ROT {
          t_item a = pop(stack);
          t_item b = pop(stack);
          t_item c = pop(stack);
          if (a.type != invalid && b.type != invalid && c.type != invalid) {
              push(stack, b.type, b.value);
              push(stack, a.type, a.value);
              push(stack, c.type, c.value);
          } else { stack_underflow(); }
      }
    | WORD {
          printf(KMAG " %s ? " KNRM "\n> ", $1);
          yyrestart(yyin);
      }
    | FORGOT {
          printf(KWHT " uh");
          fflush(stdout);
          for (int i = 0; i < rand() % 3 + 2; i++) {
              //sleep(1);
              printf(".");
              fflush(stdout);
          }
          //sleep(1);
          printf(" " KNRM);
          error = 1;
      }
    | CLEAR {
          printf("\033[2J\033[H");
      }
    | BYE {
          printf(" bye!\n");
          exit(0);
      }
    ;
    /* todo */
%%


void yyerror(const char *s){
    printf(KYEL " not ok\n" KNRM);
}
