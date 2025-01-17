Relatório Projeto \- Compiladores  
João António Faustino Vaz 2022231087   
André Peixoto Torga Teixeira 2022231134

i) Gramática re-escrita  
O código começa com a inclusão de bibliotecas como stdio.h e ast.h, essenciais para manipulação de entrada/saída e construção da AST. Funções externas, como yylex() e yyerror(), são usadas para análise léxica e tratamento de erros, enquanto a variável root armazena a raiz da AST. O comando %union define os tipos de dados utilizados, incluindo strings e nós da AST.

Os tokens, retornados pelo gocompiler.l, representam os elementos básicos da linguagem, como palavras-chave (IF, FUNC), operadores (PLUS, ASSIGN), e identificadores (IDENTIFIER). Além disso, a precedência e associatividade de operadores são especificadas para garantir a ordem correta em expressões matemáticas e lógicas.

As regras do Bison descrevem como os tokens se combinam para formar estruturas maiores. Cada regra corresponde a um componente do programa, e a lógica em C associada a elas cria nós da AST. Por exemplo:

Program: Inicia com PACKAGE IDENTIFIER SEMICOLON seguido por declarações, criando a estrutura básica do programa.  
Declarations: Podem ser declarações de variáveis ou funções, processadas recursivamente para adicionar à AST.  
VarDeclaration: Lida com declarações de variáveis, suportando múltiplos identificadores e tipos como INT, STRING, BOOL e FLOAT32.  
FuncDeclaration: Define funções com cabeçalhos(FuncHeader), parâmetros(FuncParams), e corpo(FuncBody).

A AST é construída por funções auxiliares, como newnode() para criar nós, addchild() para adicionar filhos, addchildfirst() para adicionar um filho no início da lista de filhos de um certo nó, move() para mover os filhos de um nó para outro e movechildrenend() para anexar os filhos de um nó ao final da lista de filhos de outro nó.   
Cada nó na AST representa uma construção, como uma função, declaração ou expressão.

As expressões suportam operadores binários (como PLUS e AND), operadores unários (NOT), e invocação de funções. Regras como Expr PLUS Expr criam nós para essas operações, preservando a precedência.

Regras com error identificam erros de sintaxe e ativam a variável flag\_error, garantindo que o programa lide com entradas inválidas de forma robusta.

Concluindo, a gramática traduz um programa-fonte em uma AST, representando sua lógica de maneira hierárquica. Ele suporta estruturas como funções, declarações de variáveis, comandos de controle e expressões. A AST gerada pode ser usada em etapas posteriores, como análise semântica ou geração de código, etapas que não foram concluídas.

ii) Algoritmos e estruturas de dados da AST

struct node  
{  
    enum category category;  
    char \*token;  
    struct node\_list \*children;  
    struct node\_list \*last\_child;  
};

struct node\_list  
{  
    struct node \*node;  
    struct node\_list \*next;  
};

Para a manipulação e inserção de nós na árvore criámos estas duas estruturas de dados. Cada nó da árvore terá uma categoria que foi definida anteriormente (“enum category{Program,Package,Semicolon,Parameters,...}, um token ( que não será NULL apenas quando existe um IDENTIFIER ou STRLIT ) e que conterá o IDENTIFIER em si ou a string que originou ao STRLIT. Também temos dois ponteiros para a estrutura node\_list, children e last\_children, que terão ter os filhos dos nós. O ponteiro last\_child irá permitir a inserção de filhos no final da lista ( sem ter de percorrer a lista toda).

Para a criação da árvore usamos 6 funções: 

1\. struct node \*newnode(enum category category, char \*token)  
 \-\> Cria e inicializa um nó da AST.

Aloca memória para o nó.  
Define a categoria, associa o token, e inicializa os filhos (children e last\_child) como NULL.  
Retorna o ponteiro para o novo nó.

2\. int numberchilds(struct node \*parent)  
\-\> Conta os filhos de um nó.

Retorna 0 se o nó pai ou os seus filhos forem NULL.  
Conta os filhos e retorna o total.

3\. void addchild(struct node \*parent, struct node \*child)  
\-\> Adiciona um filho no final da lista de filhos de um certo nó (pai).

Ignora se child for NULL.  
Aloca memória para o filho e insere-o no final da lista.  
Atualiza last\_child para o novo filho.

4\. void addchildfirst(struct node \*parent, struct node \*child)  
\-\> Adiciona um filho no início da lista de filhos de um certo nó (pai).

Ignora se child for NULL.  
Aloca memória para o filho e o insere no início da lista.  
Atualiza last\_child se for o único filho.

5\. void move(struct node \*destination, struct node \*actual)  
\-\>Move todos os filhos de actual para destination.

Atualiza os ponteiros children e last\_child do destino.  
Esvazia os filhos do nó original.

6\. void movechildrenend(struct node \*destination, struct node \*actual)  
\-\>Anexa os filhos de actual ao final da lista de filhos de destination.

Atualiza last\_child do destino para incluir os filhos de actual.  
Esvazia os filhos do nó original.

   