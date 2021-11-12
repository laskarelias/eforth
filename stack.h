#ifndef __stack_h
#define __stack_h
#endif

enum type {number, function, variable, constant};
typedef struct item {
    int type;
    int value;
} t_item;

typedef struct stack {
    int top;
    t_item* items;
} t_stack;

t_stack* stack_new();

void push(t_stack* s, int t, int v);
t_item pop(t_stack* s);
void print(t_stack* s);