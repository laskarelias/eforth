%option noyywrap
%option yylineno
%option nounput
%option noinput

%{
#include <stdarg.h>
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

void printerr(int n, ...) {
    va_list ptr;
    yyrestart(yyin);
    va_start(ptr, n);
    printf(" ");
    for (int i = 0; i < n; i++) {
        printf("%s", va_arg(ptr, char *));
    } 
    va_end(ptr);
    printf(KNRM "\n> ");
    return;
}

char temp[32];

extern int yylex();

t_stack* stack;
t_stack* statics;
int error;
int new_def;

int main() {
    printf(" bye or Ctrl-D to exit\n");
    error = 0;
    new_def = 0;

    stack = stack_new();
    statics = stack_new();

    do { 
        printf("> "); 
        yylex();
    } 
    while (!feof(stdin));

    return 0;
}

%}

%x BEGIN_DEF
%x IN_DEF

%%

[0-9]{1,9}                      { push(stack, number, atoi(yytext), "\0"); }
<IN_DEF>[0-9]{1,9}              { }
[-+*\/]                         { t_item a = pop(stack);
                                  t_item b = pop(stack);
                                  if (a.type != invalid && b.type != invalid) {
                                      switch (yytext[0]) {
                                          case '+': push(stack, number, b.value + a.value, "\0"); break;
                                          case '-': push(stack, number, b.value - a.value, "\0"); break;
                                          case '*': push(stack, number, b.value * a.value, "\0"); break;
                                          case '/': push(stack, number, b.value / a.value, "\0"); break;
                                          default:  push(stack, number, 0, "\0");                 break;
                                      }
                                  } else { printerr(1, KRED "stack underflow"); }
                                }
[\.]|emit                       { t_item a = pop(stack); a.type == invalid ? printerr(1, KRED "stack underflow") : printf("%c", a.value); }
:                               { BEGIN(BEGIN_DEF); }
<IN_DEF>;                       { BEGIN(INITIAL); }
drop                            { t_item a = pop(stack); if (a.type == invalid) { printerr(1, KRED "stack underflow"); } }
swap                            { t_item a = pop(stack);
                                  t_item b = pop(stack);
                                  if (a.type != invalid && b.type != invalid) {
                                      push(stack, a.type, a.value, a.name);
                                      push(stack, b.type, b.value, b.name);
                                  } else { printerr(1, KRED "stack underflow"); }
                                }
over                            { t_item a = pop(stack);
                                  t_item b = pop(stack);
                                  if (a.type != invalid && b.type != invalid) {
                                      push(stack, b.type, b.value, b.name);
                                      push(stack, a.type, a.value, a.name);
                                      push(stack, b.type, b.value, b.name);
                                  } else { printerr(1, KRED "stack underflow"); }
                                }
rot                             { t_item a = pop(stack);
                                  t_item b = pop(stack);
                                  t_item c = pop(stack);
                                  if (a.type != invalid && b.type != invalid && c.type != invalid) {
                                      push(stack, b.type, b.value, b.name);
                                      push(stack, a.type, a.value, a.name);
                                      push(stack, c.type, c.value, c.name);
                                  } else { printerr(1, KRED "stack underflow"); }
                                }
debug                           { dprint(stack); dprint(statics); }
bye                             { printf(" bye!\n"); exit(0); }
forgot                          { //TODO }
clear                           { printf("\033[2J\033[H"); }

<*>\n                           { printf(" ok "); print(stack); printf("> "); }
<BEGIN_DEF>[^ \t\n]{1,31}       { strncpy(temp, yytext, 31);
                                  temp[31] = '\0';
                                  push(statics, function, 0, temp);
                                  BEGIN(IN_DEF);
                                }
<INITIAL>[^ \t\n]{1,31}         { strncpy(temp, yytext, 31);
                                  temp[31] = '\0';
                                  seek(statics, function, 0, temp) == -1 ? printerr(3, KMAG, temp, " ?") : printf("oookay.\n") ; }
<*>[ \t]*                       { }
<*><<EOF>>                      { printf("Ctrl-D\n bye!\n"); exit(0); }

