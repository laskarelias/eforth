#include <stdio.h>
#include <stdlib.h>
#include "stack.h"

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


