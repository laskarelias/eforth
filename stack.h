#ifndef __stack_h
#define __stack_h
#endif

enum type {invalid = -1, number = 0, function, variable, constant};
typedef struct item {
    int type;
    int value;
    char name[32];
} t_item;

typedef struct stack {
    int top;
    t_item* items;
} t_stack;

t_stack* stack_new();

void push(t_stack* s, int t, int v, char* n);
int seek(t_stack* s, int t, int v, char* n);
t_item pop(t_stack* s);
void print(t_stack* s);
void dprint(t_stack* s);
