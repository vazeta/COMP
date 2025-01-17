/*Joao Antonio Faustino Vaz 2022231087 Andre Peixoto Torga Teixeira 2022231134 */

%{
#include <stdio.h>
#include "ast.h" 

int yylex(void);
int yyerror(char *);
extern int flag_error;


extern int varT;
struct node *root = NULL;

%}

%union{
    char *strval;
    struct node *node;
}

%token VAR INT FLOAT32 BOOL STRING COMMA PACKAGE SEMICOLON
%token FUNC LPAR RPAR LBRACE RBRACE LSQ RSQ
%token IF ELSE FOR RETURN PRINT PARSEINT CMDARGS
%token ASSIGN PLUS MINUS STAR DIV MOD 
%token AND OR LT GT EQ NE LE GE NOT RESERVED
%token BLANKID
%token<strval> IDENTIFIER NATURAL DECIMAL STRLIT 
%type<node> Program Declarations VarDeclaration VarSpec Type FuncDeclaration 
%type<node> Parameters FuncBody VarsAndStatements Statement StatementAux 
%type<node> Expr ParseArgs FuncInvocation FuncInvocationAux

%left OR
%left AND
%left LT GT EQ NE LE GE
%left PLUS MINUS
%left STAR DIV MOD
%right NOT

%%

Program:
    PACKAGE IDENTIFIER SEMICOLON Declarations {
        root = $4;
    }
    |PACKAGE IDENTIFIER SEMICOLON{
        root=newnode(Program,NULL);
    }
    ;

Declarations:
    FuncDeclaration SEMICOLON {
        $$ = newnode(Program, NULL); addchild($$, $1); 
    }
    | VarDeclaration SEMICOLON {
        $$ = newnode(Program, NULL); move($$, $1); 
    }
    | Declarations VarDeclaration SEMICOLON {
        $$ = $1; movechildrenend($$, $2);
    }
    | Declarations FuncDeclaration SEMICOLON {
        $$ = $1; addchild($$, $2); 
    }
    ;


VarDeclaration:
    VAR VarSpec {
        $$ = $2; 
    }
    | VAR LPAR VarSpec SEMICOLON RPAR {
        $$ = $3; 
    }
    ;

VarSpec:
    IDENTIFIER COMMA VarSpec {
        $$ = $3; struct node *node = newnode(VarDecl, NULL); addchild(node, newnode($$->children->node->children->node->category, NULL)); addchild(node, newnode(Identifier, $1)); addchildfirst($$, node); 
    }
    ;
    | IDENTIFIER Type {
        $$ = newnode(Block, NULL); struct node *node = newnode(VarDecl, NULL); addchild(node, $2); addchild(node, newnode(Identifier, $1)); addchild($$, node); 
    }
    

Type:
    INT { 
        $$ = newnode(Int, NULL); 
    }
    | STRING { 
        $$ = newnode(String, NULL);
    }
    | BOOL {
        $$ = newnode(Bool, NULL); 
    }
    | FLOAT32 {
        $$ = newnode(Float32, NULL); 
    }
    ;

FuncDeclaration:
    FUNC IDENTIFIER LPAR RPAR FuncBody {
        $$ = newnode(FuncDecl, NULL); struct node *header = newnode(FuncHeader, NULL); addchild(header, newnode(Identifier, $2)); addchild(header, newnode(FuncParams, NULL)); addchild($$, header); addchild($$, $5);
    }
    | FUNC IDENTIFIER LPAR Parameters RPAR Type FuncBody {
        $$ = newnode(FuncDecl, NULL); struct node *header = newnode(FuncHeader, NULL); addchild(header, newnode(Identifier, $2));  addchild(header, $6);addchild(header, $4); addchild($$, header); addchild($$, $7);
    }
    | FUNC IDENTIFIER LPAR RPAR Type FuncBody {
        $$ = newnode(FuncDecl, NULL); struct node *header = newnode(FuncHeader, NULL); addchild(header, newnode(Identifier, $2));  addchild(header, $5); addchild(header, newnode(FuncParams, NULL));addchild($$, header); addchild($$, $6);
    }
    | FUNC IDENTIFIER LPAR Parameters RPAR FuncBody {
        $$ = newnode(FuncDecl, NULL); struct node *header = newnode(FuncHeader, NULL); addchild(header, newnode(Identifier, $2)); addchild(header, $4); addchild($$, header); addchild($$, $6);
    }
    ;
Parameters:
    IDENTIFIER Type {
        $$ = newnode(FuncParams, NULL); struct node *param = newnode(ParamDecl, NULL); addchild(param, $2); addchild(param, newnode(Identifier, $1)); addchild($$, param); 
    }
    | Parameters COMMA IDENTIFIER Type {
        $$ = $1; struct node *param = newnode(ParamDecl, NULL); addchild(param, $4); addchild(param, newnode(Identifier, $3)); addchild($$, param); 
    }
    ;

FuncBody: 
    LBRACE VarsAndStatements RBRACE {
        { $$ = $2;}
    }
    | LBRACE RBRACE {
        $$ = newnode(FuncBody, NULL); 
    }
    ;

VarsAndStatements: 
    VarsAndStatements SEMICOLON {
        $$= $1;
    }
    | VarsAndStatements Statement SEMICOLON {
        $$ = $1; addchild($$, $2);
    }
    | Statement SEMICOLON {
        $$ = newnode(FuncBody, NULL); addchild($$, $1);
    }
    | VarsAndStatements VarDeclaration SEMICOLON {
        $$ = $1; movechildrenend($$, $2);
    }
    | VarDeclaration SEMICOLON {
        $$ = newnode(FuncBody, NULL); move($$, $1);
    }
    | SEMICOLON { 
        $$ = newnode(FuncBody, NULL);
    }
    ;
Statement: 
    IDENTIFIER ASSIGN Expr {
        $$ = newnode(Assign,NULL); addchild ($$,newnode(Identifier,$1)); addchild($$,$3);
    }
    | FOR LBRACE StatementAux RBRACE {
        $$ = newnode(For, NULL); addchild($$, $3);
    }
    | FOR LBRACE RBRACE {
        $$ = newnode(For, NULL); addchild($$,newnode(Block,NULL));
    }
    | FOR Expr LBRACE StatementAux RBRACE {
        $$ = newnode(For, NULL); addchild($$,$2);addchild($$,$4);
    }
    | FOR Expr LBRACE RBRACE {
        $$ = newnode(For, NULL); addchild($$,$2);addchild($$,newnode(Block,NULL));
    }
    | LBRACE StatementAux RBRACE{
        if (numberchilds($2) == 0) { $$ = NULL; } else if (numberchilds($2) == 1) { $$ = $2->children->node; } else { $$ = $2; }
    }
    | LBRACE RBRACE {
        $$ = NULL;
    }
    | IF Expr LBRACE StatementAux RBRACE {
        $$ = newnode(If, NULL); addchild($$, $2); addchild($$,$4); addchild($$,newnode(Block,NULL)); 
    }
    | IF Expr LBRACE RBRACE {
        $$ = newnode(If, NULL); addchild($$, $2);addchild($$,newnode(Block,NULL));addchild($$,newnode(Block,NULL));
    }
    | IF Expr LBRACE StatementAux RBRACE ELSE LBRACE StatementAux RBRACE  {
        $$ = newnode(If, NULL); addchild($$, $2); addchild($$, $4); addchild($$, $8);
    }
    | IF Expr LBRACE StatementAux RBRACE ELSE LBRACE RBRACE  {
        $$ = newnode(If, NULL); addchild($$, $2); addchild($$, $4);addchild($$,newnode(Block,NULL));
    }
    | IF Expr LBRACE RBRACE ELSE LBRACE StatementAux RBRACE {
        $$ = newnode(If, NULL); addchild($$, $2);addchild($$,newnode(Block,NULL)); addchild($$, $7);
    }
    | IF Expr LBRACE RBRACE ELSE LBRACE RBRACE  {
        $$ = newnode(If, NULL); addchild($$, $2); addchild($$, newnode(Block, NULL)); addchild($$, newnode(Block, NULL));
    }
    | PRINT LPAR Expr RPAR {
        if(flag_error == 0){$$ = newnode(Print, NULL); addchild($$, $3);}
    }
    | PRINT LPAR STRLIT RPAR {
        if(flag_error == 0){$$ = newnode(Print,NULL);addchild($$, newnode(StrLit,$3));}
    }
    | FuncInvocation {
        $$ = $1;
    }
    | ParseArgs {
        $$ = $1;
    }
    | RETURN {
        $$ = newnode(Return, NULL);
    }
    | RETURN Expr {
        $$ = newnode(Return, NULL); addchild($$,$2);
    }
    | error {flag_error = 1;}
    ;

StatementAux: 
    Statement SEMICOLON {
        $$ = newnode(Block,NULL);addchild($$,$1);
    }
    | StatementAux Statement SEMICOLON {
        $$ = $1; addchild($$,$2);
    }
    ;

ParseArgs:
    IDENTIFIER COMMA BLANKID ASSIGN PARSEINT LPAR CMDARGS LSQ Expr RSQ RPAR {
        $$ = newnode(ParseArgs, NULL); addchild($$, newnode(Identifier, $1));addchild($$, $9);
    }
    | IDENTIFIER COMMA BLANKID ASSIGN PARSEINT LPAR error RPAR { ; }
    ;

FuncInvocation:
    IDENTIFIER LPAR FuncInvocationAux RPAR {
        $$ = $3;addchildfirst($$, newnode(Identifier, $1));
    }
    | IDENTIFIER LPAR RPAR {
        $$ = newnode(Call, NULL);addchild($$, newnode(Identifier, $1));
    }
    | IDENTIFIER LPAR error RPAR {; }
    ;

FuncInvocationAux:
    Expr {
        $$ = newnode(Call,NULL) ; addchild($$,$1);
    }
    | FuncInvocationAux COMMA Expr {
        $$ = $1; addchild($$,$3);
    }
    ;


Expr:
    Expr OR Expr{
        $$ = newnode(Or, NULL); addchild($$,$1); addchild($$, $3);
    }
    | Expr AND Expr{
        $$ = newnode(And, NULL); addchild($$,$1); addchild($$, $3);
    }
    | Expr NE Expr{
        $$ = newnode(Ne, NULL); addchild($$,$1); addchild($$, $3);
    }
    | Expr LE Expr{
        $$ = newnode(Le, NULL); addchild($$,$1); addchild($$, $3);
    }
    | Expr GE Expr{
        $$ = newnode(Ge, NULL); addchild($$,$1); addchild($$, $3);
    }
    | Expr LT Expr {
        $$ = newnode(Lt, NULL); addchild($$,$1); addchild($$, $3);
    }
    | Expr GT Expr{
        $$ = newnode(Gt, NULL); addchild($$,$1); addchild($$, $3);
    }
    | Expr EQ Expr{
        $$ = newnode(Eq, NULL); addchild($$,$1); addchild($$, $3);
    }
    | Expr PLUS Expr{
        $$ = newnode(Add, NULL); addchild($$,$1); addchild($$, $3);
    }
    | Expr MINUS Expr{
        $$ = newnode(Sub, NULL); addchild($$,$1); addchild($$, $3);
    }
    | Expr STAR Expr{
        $$ = newnode(Mul, NULL); addchild($$,$1); addchild($$, $3);
    }
    | Expr DIV Expr{
        $$ = newnode(Div, NULL); addchild($$,$1); addchild($$, $3);
    }
    | Expr MOD Expr{
        $$ = newnode(Mod, NULL); addchild($$,$1); addchild($$, $3);
    }
    | MINUS Expr %prec NOT {
        $$ = newnode(Minus, NULL); addchild($$, $2);
    }
    | PLUS Expr %prec NOT {
        $$ = newnode(Plus, NULL); addchild($$, $2);
    }
    | NOT Expr{
        $$ = newnode(Not, NULL); addchild($$, $2);
    }
    | DECIMAL{
        $$ = newnode(Decimal, $1);
    }
    | IDENTIFIER{
        $$ = newnode(Identifier, $1);
    }
    | NATURAL{
        $$ = newnode(Natural, $1);
    }
    | FuncInvocation{ 
        $$ = $1;
    }
    | LPAR Expr RPAR{ 
        $$ = $2;
    }
    | LPAR error RPAR {flag_error = 1;}
    ;