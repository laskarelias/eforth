%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "stack.h"
#define YYDEBUG 1

extern int yylineno;
extern int yylex();
extern int yyparse();

extern void yyerror(const char *s);

extern t_stack* stack;
extern t_stack* statics;
extern int error;

%}

%union {
    int no;
    char sym;
}

%token <no> NUMBER;
%token <sym> MATH;
%token BYE;
%token ENTER;

%%

lines: lines line
     | line
     ;

line: words ENTER {
          printf(error ? "": " ok "); 
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
                      push(stack, number, a.value + b.value);
                      break;
                  case '-':
                      push(stack, number, a.value - b.value);
                      break;
                  case '*':
                      push(stack, number, a.value * b.value);
                      break;
                  case '/':
                      push(stack, number, a.value / b.value);
                      break;
                  default:
                      push(stack, number, 0);
                      break;
              }
          } else { 
              printf(" Stack underflow");
              error = 1;
          }
      }
    | bye
    ;
    /* todo */

bye: BYE {
        printf(" bye!\n");
        exit(0);
     }
   ;

%%


void yyerror(const char *s){
    printf(" not ok\n");
}
