#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "ast.h"

struct node *newnode(enum category category, char *token)
{
    struct node *new = (struct node *)malloc(sizeof(struct node));

    new->category = category;

    new->token = token;

    new->children = new->last_child = NULL;

    return new;
}

int numberchilds(struct node *parent)
{
    if (parent == NULL || parent->children == NULL)
    {
        return 0;
    }

    struct node_list *current = parent->children;
    int cont = 0;

    while (current != NULL)
    {
        current = current->next;
        cont++;
    }

    return cont;
}

void addchild(struct node *parent, struct node *child)
{

    if (child == NULL)
        return;

    struct node_list *new = (struct node_list *)malloc(sizeof(struct node_list));

    new->node = child;
    new->next = NULL;

    if (parent->children == NULL)
    {
        parent->children = parent->last_child = new;
    }
    else
    {
        parent->last_child->next = new;
        parent->last_child = new;
    }
}

void addchildfirst(struct node *parent, struct node *child)
{
    if (child == NULL)
        return;

    struct node_list *no = (struct node_list *)malloc(sizeof(struct node_list));

    no->node = child;
    no->next = parent->children;

    parent->children = no;
    if (parent->last_child == NULL)
    {
        parent->last_child = no;
    }
}

void move(struct node *destination, struct node *actual)
{
    destination->children = actual->children;
    destination->last_child = actual->last_child;

    actual->children = NULL;
    actual->last_child = NULL;
}

void movechildrenend(struct node *destination, struct node *actual)
{
    destination->last_child->next = actual->children;
    destination->last_child = actual->last_child;

    actual->children = NULL;
    actual->last_child = NULL;
}
