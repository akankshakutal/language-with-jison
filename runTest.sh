echo $* > calc
jison ./clojureParser.jison && node ./clojureParser.js calc