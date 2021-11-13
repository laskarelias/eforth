#include <stdio.h>
#include "stack.h"

extern int yyparse();

t_stack* stack;
t_stack* statics;
int error;

int main() {
    #ifdef YYDEBUG
        yydebug = 1;
    #endif
        #define ECHO
    printf(" bye or Ctrl-D to exit\n");
    error = 0;

    stack = stack_new();
    statics = stack_new();

    do { printf("> "); yyparse(); } while (!feof(stdin));
    return 0;
}


