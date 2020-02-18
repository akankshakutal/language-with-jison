echo $* > calc
jison ./expression-example.jison && node ./expression-example.js calc