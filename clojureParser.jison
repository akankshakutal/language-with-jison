
/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
"["                   return '['
"]"                   return ']'
"'"                   return "'"
"("                   return '('
")"                   return ')'
"def"                 return 'DEF'
"defn"                return 'DEFN'
[a-zA-Z][a-zA-Z0-9]*  return 'ID'
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

%start expressions

%% /* language grammar */

expressions
    : e EOF
        { 
        const convertToJS= require("./clojureConverter.js")
        const fs = require('fs');
        const jsCode = convertToJS($1)

        fs.writeFile("./test.js",jsCode , function(err) {
            if(err) return err
        });

        return jsCode; 
        }
    ;

e
    : "(" operator args ")"
        {$$ = [$2].concat($3);}
    | "(" DEF ID expr ")"
        {$$ = ["=",$3].concat($4);}
    | vector
        {$$ = $1;}
    | "(" DEFN ID vector e")"
        {$$ = ["Function", $3, $4, $5];}
    ;

vector 
    : "[" args "]"    
        {$$ = ["Array", $2];}
    // | "[" params "]"
    //     {$$ = ["Array", $2];}
    ;

args  
    : NUMBER
        {$$= Number(yytext);}
    | NUMBER e
        {$$ = [Number($1),$2];}
    | NUMBER args
        {$$ = [Number($1)].concat($2)}
    | e args
        {$$ = [$1].concat($2)}
    | e e
        {$$ = [$1,$2] }
    | params
        {$$ = $1}
    ;

params
    :ID params
        {$$ = [$1].concat($2);}
    |ID
        {$$ = $1}
    ;

expr
    : e
        {$$ = [$1];}
    | args
        {$$ = [$1]}
    |"'" ID "'"
        {$$=[$1, $2, $3].join("");}
    | "(" ")"
        {$$=[$1,$2].join("")}
    
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


