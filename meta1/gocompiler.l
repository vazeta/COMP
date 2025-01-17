/*Joao Antonio Faustino Vaz 2022231087 Andre Peixoto Torga Teixeira 2022231134 */

%{
    /* place here any C variables and definitions */
    int line = 1;
    int column = 1;
    char buffer[8192];
    int bufferSize = 0; 
    int i = 0;
    int flag = 0;
    int C_erro = 0;
    int line_up=0;
    int varL = 0;
    int veriErro = 0;
%}
digit   [0-9]
letter [a-zA-Z_]
hexaLetters [a-fA-F]
octo [0-7]
error [8-9]
%X COMMENT STATE
%%
"0"({octo}*{error}+{digit}*)    {yytext[strcspn(yytext, "\n")] = '\0';printf("Line %d, column %d: invalid octal constant (%s)\n", line, column,yytext);column+=yyleng;}
"0"{octo}+           {if(varL == 1){printf("NATURAL(%s)\n",yytext);}; column+=yyleng;flag = 1;BEGIN(INITIAL);} 
{digit}+             {if(varL == 1){printf("NATURAL(%s)\n",yytext);}; column+=yyleng;flag = 1;BEGIN(INITIAL);}
({digit}+("."{digit}*)?|("."{digit}+))(("e"|"E")("+"|"-")?{digit}+)?    {if(varL == 1){printf("DECIMAL(%s)\n",yytext);}; column += yyleng;; flag = 1;BEGIN(INITIAL);}                   
("0x"|"0X")({digit}+|{hexaLetters}+)+   {if(varL == 1){printf("NATURAL(%s)\n",yytext);}; column+=yyleng;flag = 1;BEGIN(INITIAL);}  

" "     {column+=1;}
"\t"    {column+=1;}
\r|\r\n|\n   {line+=1;column = 1;if(flag==1 && varL == 1){printf("SEMICOLON\n");};flag = 0;}
int         {if(varL == 1){printf("INT\n");}; column+=yyleng;flag = 0;}
float32     {if(varL == 1){printf("FLOAT32\n");}; column+=yyleng;flag = 0;}
if          {if(varL == 1){printf("IF\n");}; column+=yyleng;flag = 0;}
else        {if(varL == 1){printf("ELSE\n");}; column+=yyleng;flag = 0;}
package     {if(varL == 1){printf("PACKAGE\n");}; column+=yyleng;flag = 0;}
return      {if(varL == 1){printf("RETURN\n");}; column+=yyleng;flag = 1;BEGIN(INITIAL);}
for         {if(varL == 1){printf("FOR\n");}; column+=yyleng;flag = 0;}
var         {if(varL == 1){printf("VAR\n");}; column+=yyleng;flag = 0;}
bool        {if(varL == 1){printf("BOOL\n");}; column+=yyleng;flag = 0;}
string      {if(varL == 1){printf("STRING\n");}; column+=yyleng;flag = 0;}
fmt.Println     {if(varL == 1){printf("PRINT\n");}; column+=yyleng;flag = 0;}
strconv.Atoi    {if(varL == 1){printf("PARSEINT\n");}; column+=yyleng;flag = 0;}
func            {if(varL == 1){printf("FUNC\n");}; column+=yyleng;flag = 0;}
os.Args         {if(varL == 1){printf("CMDARGS\n");}; column+=yyleng;flag = 0;}
"="     {if(varL == 1){printf("ASSIGN\n");};column+=yyleng;flag = 0;}
"=="    {if(varL == 1){printf("EQ\n");};column+=yyleng;flag = 0;}
","     {if(varL == 1){printf("COMMA\n");};column+=yyleng;flag = 0;}
"*"     {if(varL == 1){printf("STAR\n");};column+=yyleng;flag = 0;}
"/"     {if(varL == 1){printf("DIV\n");};column+=yyleng;flag = 0;}
"+"     {if(varL == 1){printf("PLUS\n");};column+=yyleng;flag = 0;}
"-"     {if(varL == 1){printf("MINUS\n");};column+=yyleng;flag = 0;}
";"     {if(varL == 1){printf("SEMICOLON\n");};column+=yyleng;flag = 0;} 
"_"     {if(varL == 1){printf("BLANKID\n");};column+=yyleng;flag = 0;} 
">="    {if(varL == 1){printf("GE\n");};column+=yyleng;flag = 0;}
">"     {if(varL == 1){printf("GT\n");};column+=yyleng;flag = 0;}
"{"     {if(varL == 1){printf("LBRACE\n");};column+=yyleng;flag = 0;}
"}"     {if(varL == 1){printf("RBRACE\n");};column+=yyleng;flag = 1;}
"<="    {if(varL == 1){printf("LE\n");};column+=yyleng;flag = 0;}
"("     {if(varL == 1){printf("LPAR\n");};column+=yyleng;flag = 0;}
")"     {if(varL == 1){printf("RPAR\n");};column+=yyleng;flag = 1;BEGIN(INITIAL);}
"["     {if(varL == 1){printf("LSQ\n");};column+=yyleng;flag = 0;}
"]"     {if(varL == 1){printf("RSQ\n");};column+=yyleng;flag = 1;BEGIN(INITIAL);}
"<"     {if(varL == 1){printf("LT\n");};column+=yyleng;flag = 0;}
"%"     {if(varL == 1){printf("MOD\n");};column+=yyleng;flag = 0;}
"!="    {if(varL == 1){printf("NE\n");};column+=yyleng;flag = 0;}
"!"     {if(varL == 1){printf("NOT\n");};column+=yyleng;flag = 0;}
"&&"    {if(varL == 1){printf("AND\n");};column+=yyleng;flag = 0;}
"||"    {if(varL == 1){printf("OR\n");};column+=yyleng;flag = 0;}

"--"        {if(varL == 1){printf("RESERVED(--)\n");}; column+=yyleng;flag = 0;}
"++"        {if(varL == 1){printf("RESERVED(++)\n");}; column+=yyleng;flag = 0;}
break       {if(varL == 1){printf("RESERVED(break)\n");}; column+=yyleng;flag = 0;}
case        {if(varL == 1){printf("RESERVED(case)\n");}; column+=yyleng;flag = 0;}
chan        {if(varL == 1){printf("RESERVED(chan)\n");}; column+=yyleng;flag = 0;}
const       {if(varL == 1){printf("RESERVED(const)\n");}; column+=yyleng;flag = 0;}
continue    {if(varL == 1){printf("RESERVED(continue)\n");}; column+=yyleng;flag = 0;}
default     {if(varL == 1){printf("RESERVED(default)\n");}; column+=yyleng;flag = 0;}
defer       {if(varL == 1){printf("RESERVED(defer)\n");}; column+=yyleng;flag = 0;}
fallthrough     {if(varL == 1){printf("RESERVED(fallthrough)\n");}; column+=yyleng;flag = 0;}
go              {if(varL == 1){printf("RESERVED(go)\n");}; column+=yyleng;flag = 0;}
goto            {if(varL == 1){printf("RESERVED(goto)\n");}; column+=yyleng;flag = 0;}
import          {if(varL == 1){printf("RESERVED(import)\n");}; column+=yyleng;flag = 0;}
interface       {if(varL == 1){printf("RESERVED(interface)\n");}; column+=yyleng;flag = 0;}
map             {if(varL == 1){printf("RESERVED(map)\n");}; column+=yyleng;flag = 0;}
range           {if(varL == 1){printf("RESERVED(range)\n");}; column+=yyleng;flag = 0;}
select          {if(varL == 1){printf("RESERVED(select)\n");}; column+=yyleng;flag = 0;}
struct          {if(varL == 1){printf("RESERVED(struct)\n");}; column+=yyleng;flag = 0;}
switch          {if(varL == 1){printf("RESERVED(switch)\n");}; column+=yyleng;flag = 0;}
type            {if(varL == 1){printf("RESERVED(type)\n");}; column+=yyleng;flag = 0;}

{letter}({letter}*{digit}*)*   {if(varL == 1){printf("IDENTIFIER(%s)\n",yytext);};column+=yyleng;flag = 1;BEGIN(INITIAL);}
<INITIAL><<EOF>>          {if(flag==1 && varL == 1){printf("SEMICOLON\n");};return 0;}  

\"      {C_erro=column; i = 0; buffer[0] = '\0';buffer[i++] = yytext[0]; buffer[i] = '\0'; BEGIN(STATE);column+=yyleng;}
<STATE>\\n      {buffer[i++] = yytext[0]; buffer[i++] = yytext[1]; buffer[i] = '\0'; column += yyleng;}
<STATE>\\r      {buffer[i++] = yytext[0]; buffer[i++] = yytext[1]; buffer[i] = '\0'; column += yyleng;}
<STATE>\\f      {buffer[i++] = yytext[0]; buffer[i++] = yytext[1]; buffer[i] = '\0'; column += yyleng;}
<STATE>\\t      {buffer[i++] = yytext[0]; buffer[i++] = yytext[1]; buffer[i] = '\0'; column += yyleng;}
<STATE>\\\\     {buffer[i++] = yytext[0]; buffer[i++] = yytext[1]; buffer[i] = '\0'; column += yyleng;}
<STATE>\\\"     {buffer[i++] = yytext[0]; buffer[i++] = yytext[1]; buffer[i] = '\0'; column += yyleng;}
<STATE>\\(.|"")    {printf("Line %d, column %d: invalid escape sequence (%s)\n",line,column,yytext);veriErro = 1;column+=yyleng;}

<STATE>[^\"\n]     {buffer[i++] = yytext[0]; buffer[i] = '\0'; column += yyleng;}
<STATE>\"          {buffer[i++] = yytext[0]; buffer[i] = '\0';if(varL == 1 && veriErro == 0){printf("STRLIT(%s)\n", buffer);};if(veriErro == 0){flag = 1;}; column+=1;veriErro = 0;BEGIN(INITIAL);}
<STATE>\n|\r|\r\n  {column-=i;printf("Line %d, column %d: unterminated string literal\n", line, C_erro);veriErro = 0;BEGIN(INITIAL); line += 1; column = 1;}
<STATE><<EOF>>     {column-=i;printf("Line %d, column %d: unterminated string literal\n", line, C_erro);return 0;}

"/*"        { C_erro=column;BEGIN(COMMENT);column+=yyleng;line_up=line;}
<COMMENT>.  {; column+=yyleng;}
<COMMENT>\n|\r|\r\n    {column = 1; line += 1;}
<COMMENT><<EOF>>       {printf("Line %d, column %d: unterminated comment\n", line_up, C_erro);return 0;}
<COMMENT>"*/"    {column+=yyleng;BEGIN(INITIAL);}

"//".*                             { ; }

. {printf("Line %d, column %d: illegal character (%s)\n", line, column ,yytext);column+=1;}

%%
extern int yylex();
int main(int argc, char**  argv) {
    for(int i = 1; i< argc;i++){
        if(!strcmp(argv[i],"-l")){
            varL = 1;
            break;
        }
    }
    yylex();    /* run the lexical analysis automaton */
    
    return 0;
}
int yywrap() {  /* called on EOF, return 1 to terminate */
    return 1;
}