
/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
"("                   return '('
")"                   return ')'
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%left '+' '-'
%left '*' '/'

%start expressions

%% /* language grammar */

expressions
    : e EOF
        { typeof console !== 'undefined' ? console.log($1) : print($1);
          return $1; }
    ;

e
    : "(" operator args ")"
        {$$ = [$2].concat($3)}
    ;
args  
    : NUMBER
        {$$= Number(yytext);}
    | NUMBER e
        {$$ = [Number($1),$2];}
    | e NUMBER
        {$$ = [$1,Number($2)]}
    | NUMBER args
        {$$ = [Number($1),$2]}
    | e e
        {$$ =[$1,$2] }
    ;
operator
    : "+"
        {$$ = $1;}
    | "-"
        {$$ = $1;}
    | "*"
        {$$ = $1;}
    | "/"
        {$$ = $1;}
    ;

