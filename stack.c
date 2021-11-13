#include <stdlib.h>
#include <stdio.h>
#include "stack.h"

t_stack* stack_new() {   
    t_stack* s = (t_stack *)malloc(sizeof(t_stack));
    t_item* i = (t_item *)malloc(sizeof(t_item));
    s->items = i;
    s->top = 0;
    return s;
}

void push(t_stack* s, int t, int v) {
    s->items = realloc(s->items, ++s->top * sizeof(t_item));
    s->items[s->top - 1].value = v;
    s->items[s->top - 1].type = t;
}

t_item pop(t_stack* s) {
    t_item null = {.type = invalid, .value = 0};
    t_item i = s->top ? s->items[--s->top] : null;
    s->items = realloc(s->items, s->top * sizeof(t_item));
    return i;
}

void dprint(t_stack* s) {
    for (int i = 0; i < s->top; i++) {
        printf("%d: %d with value %d\n", i, s->items[i].type, s->items[i].value);
    }
    printf("==\n");
    return;
}

void print(t_stack* s) {
    for (int i = 0; i < s->top; i++) {
        printf(s->items[i].type ? "/%d " : "%d ", s->items[i].value);
    }
    printf("\n");
    return;
}
