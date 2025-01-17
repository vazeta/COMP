/*Joao Antonio Faustino Vaz 2022231087 Andre Peixoto Torga Teixeira 2022231134 */

%{
    #include "y.tab.h"
    #include <string.h>
    #include "ast.h"
    int yyparse();
    int line = 1;
    int column = 1;
    char buffer[8192];
    char mess[8192] = "";
    int bufferSize = 0; 
    int i = 0;
    int flag = 0;
    
    int C_erro = 0;
    int line_up=0;
    int varL = 0;
    int varT = 0;
    int veriErro = 0;
    int ultima_coluna = 0;
    int flag_error=0;
    int flag_newline = 0;
    extern struct node *root;
    char *category_name[] = names;
%}
digit   [0-9]
letter [a-zA-Z_]
hexaLetters [a-fA-F]
octo [0-7]
error [8-9]
%x COMMENT STATE
%%
"0"({octo}*{error}+{digit}*)    {column+=yyleng;flag_newline = 0;yytext[strcspn(yytext, "\n")] = '\0';printf("Line %d, column %d: invalid octal constant (%s)\n", line, column,yytext);}
"0"{octo}+           {column+=yyleng;flag = 1;flag_newline = 0;if(varL == 1){printf("NATURAL(%s)\n",yytext);}else{yylval.strval = strdup(yytext);return NATURAL;};} 
{digit}+             {column+=yyleng;flag = 1;flag_newline = 0;if(varL == 1){printf("NATURAL(%s)\n",yytext);}else{yylval.strval = strdup(yytext);return NATURAL;};}
({digit}+("."{digit}*)?|("."{digit}+))(("e"|"E")("+"|"-")?{digit}+)?    {column += yyleng;; flag = 1;flag_newline = 0;if(varL == 1){printf("DECIMAL(%s)\n",yytext);}else{yylval.strval = strdup(yytext);return DECIMAL;};}                   
("0x"|"0X")({digit}+|{hexaLetters}+)+   {column+=yyleng;flag = 1;flag_newline = 0;if(varL == 1){printf("NATURAL(%s)\n",yytext);}else{yylval.strval = strdup(yytext);return NATURAL;};}  

" "     {flag_newline = 0;column+=1;}
\n|\r|\r\n   {flag_newline = 1;ultima_coluna = column;line+=1;column = 1;if(flag==1 && varL == 1){flag = 0;printf("SEMICOLON\n");}else if(flag==1 && varT == 1){flag = 0;return SEMICOLON;};}
"\t"    {flag_newline = 0;column+=1;}
int         {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("INT\n");}else{return INT;};}
float32     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("FLOAT32\n");}else{return FLOAT32;};flag = 0;}
if          {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("IF\n");}else{return IF;};flag = 0;}
else        {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("ELSE\n");}else{return ELSE;};flag = 0;}
package     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("PACKAGE\n");}else{return PACKAGE;};flag = 0;}
return      {flag_newline = 0;flag = 1;column+=yyleng;if(varL == 1){printf("RETURN\n");}else{return RETURN;};BEGIN(INITIAL);}
for         {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("FOR\n");}else{return FOR;};flag = 0;}
var         {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("VAR\n");}else{return VAR;}; flag = 0;}
bool        {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("BOOL\n");}else{return BOOL;};flag = 0;}
string      {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("STRING\n");}else{return STRING;}; flag = 0;}
fmt.Println     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("PRINT\n");}else{return PRINT;};flag = 0;}
strconv.Atoi    {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("PARSEINT\n");}else{return PARSEINT;};flag = 0;}
func            {flag = 0;flag_newline = 0;column+=yyleng;flag = 0;if(varL == 1){printf("FUNC\n");}else{return FUNC;};}
os.Args         {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("CMDARGS\n");}else{return CMDARGS;}; flag = 0;}
";"     {flag_newline = 0;column+=yyleng;flag = 0;if(varL == 1){printf("SEMICOLON\n");}else{return SEMICOLON;};} 
"="     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("ASSIGN\n");}else{return ASSIGN;};flag = 0;}
"=="    {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("EQ\n");}else{return EQ;};flag = 0;}
","     {flag_newline = 0;flag = 0;column+=yyleng;if(varL == 1){printf("COMMA\n");}else{return COMMA;};}
"*"     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("STAR\n");}else{return STAR;};flag = 0;}
"/"     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("DIV\n");}else{return DIV;};flag = 0;}
"+"     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("PLUS\n");}else{return PLUS;};flag = 0;}
"-"     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("MINUS\n");}else{return MINUS;};flag = 0;}
"_"     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("BLANKID\n");}else{return BLANKID;};flag = 0;} 
">="    {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("GE\n");}else{return GE;};flag = 0;}
">"     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("GT\n");}else{return GT;};flag = 0;}
"{"     {flag_newline = 0;column+=yyleng;flag = 0;if(varL == 1){printf("LBRACE\n");}else{return LBRACE;};}
"}"     {flag_newline = 0;column+=yyleng;flag = 1;if(varL == 1){printf("RBRACE\n");}else{return RBRACE;};}
"<="    {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("LE\n");}else{return LE;};flag = 0;}
"("     {flag_newline = 0;column+=yyleng;flag = 0;if(varL == 1){printf("LPAR\n");}else{return LPAR;};}
")"     {flag_newline = 0;column+=yyleng;flag = 1;if(varL == 1){printf("RPAR\n");}else{return RPAR;};BEGIN(INITIAL);}
"["     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("LSQ\n");}else{return LSQ;};flag = 0;}
"]"     {flag_newline = 0;column+=yyleng;flag = 1;if(varL == 1){printf("RSQ\n");}else{return RSQ;};BEGIN(INITIAL);}
"<"     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("LT\n");}else{return LT;};flag = 0;}
"%"     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("MOD\n");}else{return MOD;};flag = 0;}
"!="    {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("NE\n");}else{return NE;};flag = 0;}
"!"     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("NOT\n");}else{return NOT;};flag = 0;}
"&&"    {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("AND\n");}else{return AND;};flag = 0;}
"||"    {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("OR\n");}else{return OR;};flag = 0;}

"--"        {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(--)\n");};flag = 0;if(varT == 1){return RESERVED;};}
"++"        {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(++)\n");};flag = 0;if(varT == 1){return RESERVED;};}
break       {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(break)\n");};flag = 0;}
case        {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(case)\n");};flag = 0;}
chan        {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(chan)\n");};flag = 0;}
const       {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(const)\n");};flag = 0;}
continue    {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(continue)\n");};flag = 0;}
default     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(default)\n");};flag = 0;}
defer       {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(defer)\n");};flag = 0;}
fallthrough     {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(fallthrough)\n");};flag = 0;}
go              {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(go)\n");};flag = 0;}
goto            {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(goto)\n");};flag = 0;}
import          {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(import)\n");};flag = 0;}
interface       {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(interface)\n");};flag = 0;}
map             {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(map)\n");};flag = 0;}
range           {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(range)\n");};flag = 0;}
select          {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(select)\n");};flag = 0;}
struct          {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(struct)\n");};flag = 0;}
switch          {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(switch)\n");};flag = 0;}
type            {flag = 0;flag_newline = 0;column+=yyleng;if(varL == 1){printf("RESERVED(type)\n");}; flag = 0;}

{letter}({letter}*{digit}*)*   {flag_newline = 0;column+=yyleng;flag = 1;yylval.strval = strdup(yytext);if(varL == 1){printf("IDENTIFIER(%s)\n",yytext);}else{return IDENTIFIER;};}
<INITIAL><<EOF>>          {flag_newline = 0;if(flag==1 && varL == 1){flag = 0;printf("SEMICOLON\n");return 0;}else if(flag == 1){flag = 0;return SEMICOLON;}else if(flag == 0){return 0;};} 

\"      {veriErro = 0;flag_newline = 0;C_erro=column; i = 0; buffer[0] = '\0'; buffer[i++] = yytext[0]; buffer[i] = '\0'; BEGIN(STATE); column += yyleng;}
<STATE>\\n      {flag_newline = 0;buffer[i++] = yytext[0]; buffer[i++] = yytext[1]; buffer[i] = '\0'; column += yyleng;}
<STATE>\\r      {flag_newline = 0;buffer[i++] = yytext[0]; buffer[i++] = yytext[1]; buffer[i] = '\0'; column += yyleng;}
<STATE>\\f      {flag_newline = 0;buffer[i++] = yytext[0]; buffer[i++] = yytext[1]; buffer[i] = '\0'; column += yyleng;}
<STATE>\\t      {flag_newline = 0;buffer[i++] = yytext[0]; buffer[i++] = yytext[1]; buffer[i] = '\0'; column += yyleng;}
<STATE>\\\\     {flag_newline = 0;buffer[i++] = yytext[0]; buffer[i++] = yytext[1]; buffer[i] = '\0'; column += yyleng;}
<STATE>\\\"     {flag_newline = 0;buffer[i++] = yytext[0]; buffer[i++] = yytext[1]; buffer[i] = '\0'; column += yyleng;}
<STATE>\\(.|"") {flag_newline = 0;printf("Line %d, column %d: invalid escape sequence (%s)\n", line, column, yytext); veriErro = 1; column += yyleng;}

<STATE>[^\"\n]  {flag_newline = 0;buffer[i++] = yytext[0]; buffer[i] = '\0'; column += yyleng;}
<STATE>\"       {
    flag_newline = 0;
    buffer[i++] = yytext[0]; 
    buffer[i] = '\0';
    column += 1;

    if (veriErro == 0) {
        if (varL == 1) {
            printf("STRLIT(%s)\n", buffer);
        } else {
            yylval.strval = strdup(buffer);
            strcpy(mess,strdup(buffer));
            BEGIN(INITIAL);
            return STRLIT;
        }
    }
    BEGIN(INITIAL);
}
<STATE>\n|\r|\r\n {
    flag_newline = 0;
    column -= i;
    if(varT == 1 && veriErro == 1){
        printf("Line %d, column %d: syntax error: %c\n", line, column+1, (char)buffer[1]);
        return 0;
    }
    printf("Line %d, column %d: unterminated string literal\n", line, C_erro);
    veriErro = 0;
    BEGIN(INITIAL);
    line += 1;
    column = 1;
}
<STATE><<EOF>>  {
    flag_newline = 0;
    column -= i;
    printf("Line %d, column %d: unterminated string literal\n", line, C_erro);
    return 0;
}


"/*"        {flag_newline = 0;C_erro=column;BEGIN(COMMENT);column+=yyleng;line_up=line;}
<COMMENT>.  {flag_newline = 0;; column+=yyleng;}
<COMMENT>\n|\r|\r\n    {flag_newline = 0;column = 1; line += 1;}
<COMMENT><<EOF>>       {flag_newline = 0;printf("Line %d, column %d: unterminated comment\n", line_up, C_erro);return 0;}
<COMMENT>"*/"    {flag_newline = 0;column+=yyleng;BEGIN(INITIAL);}

"//".*                             { ; }

. {flag_newline = 0;printf("Line %d, column %d: illegal character (%s)\n", line, column ,yytext);column+=1;}

%%
extern int yylex();

void show(struct node* node, int depth) {
    for (int i = 0; i < depth; i++) {
        printf("..");
    }

    if (node->token == NULL) {
        printf("%s\n", category_name[node->category]);
    } else {
        printf("%s(%s)\n", category_name[node->category], node->token); 
    }

    for (struct node_list* child = node->children; child != NULL; child = child->next) {
        show(child->node, depth + 1);
    }
}

int main(int argc, char** argv) {
    
    for (int i = 1; i < argc; i++) {
        if(!strcmp(argv[i], "-l")) {
            varL = 1;
            break;
        }
        else if (strcmp(argv[i],"-t") == 0) {
			varT = 1;
            break;
            
		}
    }
    if (varL)
        yylex();
    else
        yyparse();
        
   if(varT && !flag_error) show(root,0);

    return 0;
}
int yywrap() {  /* called on EOF, return 1 to terminate */
    return 1;
}

void yyerror(char* s) {
    flag_error=1;
    if (yytext[0] == '"') {
        printf("Line %d, column %d: %s: %s\n", line, (int)(column - strlen(mess)) , s, buffer);
    }
    else if(flag_newline == 0){
        if(column==1){
            column=2;
        }
	    printf("Line %d, column %d: %s: %s\n", line, column - yyleng, s, yytext);
    }
    else if(flag_newline == 1){
        printf("Line %d, column %d: %s: %s\n", line-1, ultima_coluna, s, yytext);
    }
    else{
        printf("Line %d, column %d: %s: %s\n", line, column - yyleng, s, yytext);
    }
    strcpy(mess,"");
    flag_newline = 0;
}