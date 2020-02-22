const _ = require("lodash");

const insertSymbol = function(list) {
  const symbol = list.shift();

  const result = list.reduce((acc, element) => {
    if (Array.isArray(element)) {
      const temp = ["(", insertSymbol(element), ")"];
      acc.push(temp.join(" "), symbol);
    } else acc.push(element, symbol);
    return acc;
  }, []);

  if (result[result.length - 1] == symbol) result.pop();
  return result.join(" ");
};

const defineVariable = expression => {
  return Array.isArray(expression) ? insertSymbol(expression) : expression;
};

const convertToJS = tree => {
  switch (tree[0]) {
    case "=": {
      return `const ${tree[1]} = ${defineVariable(tree[2])};`;
    }
    case "+":
    case "-":
    case "*":
    case "/":
      return insertSymbol(tree);
  }
};

module.exports = convertToJS;
