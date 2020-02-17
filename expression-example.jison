
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
    :'+' e  e
        {$$ = [$1 ,$2, $3]}
    |'-' e  e
         {$$ = [$1 ,$2, $3]}
    |'*' e e
         {$$ = [$1 ,$2, $3]}
    |'/' e e
         {$$ = [$1 ,$2, $3]}
    | NUMBER
        {$$ = Number(yytext);}
    | '(' e ')'
        {$$ = $2;}
    ;

