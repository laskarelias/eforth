#include <stdio.h>
#include "stack.h"

int main() {
    printf("[e4i - easy forth implementation]\n");
    //yyparse();

    t_stack* test = stack_new();

    push(test, variable, 4);
    print(test);
    push(test, number, 5);
    print(test);
    push(test, constant, 2);
    print(test);
    push(test, function, 33);
    print(test);
    pop(test);
    print(test);
    pop(test);
    print(test);
    push(test, variable, 4);
    print(test);

    return 0;
}


