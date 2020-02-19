
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
        {{
        const insertSymbol = (symbol, list) => {
            if (Array.isArray(list)) {
                list.forEach(element => {
                    if (element instanceof Array) {
                        if (element.length == 2) 
                            element.unshift(symbol);
                        insertSymbol(symbol, element);
                    }
                })
            }
            return list;
        };
        insertSymbol($2, $3);
        $$ = [$2].concat($3);
        }}
    | NUMBER
        {$$= Number(yytext);}
    ;
args  
    : args e
        {$$ =[$1,$2] }
    | e
        {$$ = $1}
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

