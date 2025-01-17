#ifndef _AST_H
#define _AST_H
#define NODE_TOKEN

enum category
{
    Program,
    Package,
    Semicolon,
    Parameters,
    Parameter,
    Arguments,
    Integer,
    Double,
    Identifier,
    Natural,
    Decimal,
    If,
    Int,
    Float32,
    Bool,
    String,
    Or,
    And,
    Lt,
    Gt,
    Eq,
    Ne,
    Le,
    Ge,
    Add,
    Minus,
    Sub,
    Mul,
    Mod,
    Not,
    Div,
    Call,
    ParseArgs,
    Print,
    For,
    Return,
    FuncBody,
    Assign,
    FuncDecl,
    FuncParams,
    Block,
    StrLit,
    FuncHeader,
    VarDecl,
    Plus,
    ParamDecl
};
#define names {"Program", "Package", "Semicolon", "Parameters", "Parameter", "Arguments", "Integer", "Double", "Identifier", "Natural", "Decimal", "If", "Int", "Float32", "Bool", "String", "Or", "And", "Lt", "Gt", "Eq", "Ne", "Le", "Ge", "Add", "Minus", "Sub", "Mul", "Mod", "Not", "Div", "Call", "ParseArgs", "Print", "For", "Return", "FuncBody", "Assign", "FuncDecl", "FuncParams", "Block", "StrLit", "FuncHeader", "VarDecl", "Plus", "ParamDecl"}

struct node
{
    enum category category;
    char *token;
    struct node_list *children;
    struct node_list *last_child;
};

struct node_list
{
    struct node *node;
    struct node_list *next;
};

struct node *newnode(enum category category, char *token);
void addchild(struct node *parent, struct node *child);
void addchildfirst(struct node *parent, struct node *child);
int numberchilds(struct node *parent);
void move(struct node *destination, struct node *source);
void show(struct node *node, int depth);
void movechildrenend(struct node *destination, struct node *source);

#endif
