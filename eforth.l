%option noyywrap
%option yylineno
%option nounput
%option noinput

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include "stack.h"

#define KNRM  "\x1B[0m"
#define KRED  "\x1B[31m"
#define KGRN  "\x1B[32m"
#define KYEL  "\x1B[33m"
#define KBLU  "\x1B[34m"
#define KMAG  "\x1B[35m"
#define KCYN  "\x1B[36m"
#define KWHT  "\x1B[37m"

extern t_stack* stack;
extern t_stack* statics;
extern int error;

void stack_underflow() {
    yyrestart(yyin);
    printf(KRED " stack underflow" KNRM "\n> ");
    return;
}

char temp[32];

%}

%%

[0-9]{1,9}      { push(stack, number, atoi(yytext), "\0"); }
[-+*\/]         { t_item a = pop(stack);
                  t_item b = pop(stack);
                  if (a.type != invalid && b.type != invalid) {
                      switch (yytext[0]) {
                          case '+':
                              push(stack, number, b.value + a.value, "\0");
                              break;
                          case '-':
                              push(stack, number, b.value - a.value, "\0");
                              break;
                          case '*':
                              push(stack, number, b.value * a.value, "\0");
                              break;
                          case '/':
                              push(stack, number, b.value / a.value, "\0");
                              break;
                          default:
                              push(stack, number, 0, "\0");
                              break;
                      }
                  } else { stack_underflow(); }
                }
[\.]            { t_item a = pop(stack);
                  a.type == invalid ? stack_underflow() : printf("%c", a.value); 
                }
emit            { t_item a = pop(stack);
                  a.type == invalid ? stack_underflow() : printf("%c", a.value);
                }
drop            { t_item a = pop(stack);
                  if (a.type == invalid) { stack_underflow(); }
                }
swap            { t_item a = pop(stack);
                  t_item b = pop(stack);
                  if (a.type != invalid && b.type != invalid) {
                      push(stack, a.type, a.value, a.name);
                      push(stack, b.type, b.value, b.name);
                  } else { stack_underflow(); }
                }
over            { t_item a = pop(stack);
                  t_item b = pop(stack);
                  if (a.type != invalid && b.type != invalid) {
                      push(stack, b.type, b.value, b.name);
                      push(stack, a.type, a.value, a.name);
                      push(stack, b.type, b.value, b.name);
                  } else { stack_underflow(); } 
                }
rot             { t_item a = pop(stack);
                  t_item b = pop(stack);
                  t_item c = pop(stack);
                  if (a.type != invalid && b.type != invalid && c.type != invalid) {
                      push(stack, b.type, b.value, b.name);
                      push(stack, a.type, a.value, b.name);
                      push(stack, c.type, c.value, b.name);
                  } else { stack_underflow(); }
                }
debug           { dprint(stack); dprint(statics); }
bye             { printf(" bye!\n");
                  exit(0);
                }
forgot          { //TODO 
                }
clear           { printf("\033[2J\033[H"); }
\n              { print(stack);
                  printf("> ");
                }
[^ \t\n]{1,31}  { strncpy(temp, yytext, 31);
                  temp[31] = '\0';
                  push(statics, function, 0, temp);
                }
[ \t]*        { }
<<EOF>>       { printf("Ctrl-D\n bye!\n"); 
                exit(0); 
              }

