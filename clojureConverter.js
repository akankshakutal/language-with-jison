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
  if (expression[0] == "Array") {
    return "[" + expression[1].toString() + "]";
  }
  if (Array.isArray(expression)) {
    return insertSymbol(expression);
  }
  return expression;
};

const defineFunction = tree => {
  const fnName = tree[1];
  const args = tree[2].slice(1);
  const body = insertSymbol(tree[3]);
  return `const ${fnName} = function (${args}) {
    return ${body};
  }`;
};

const convertToJS = tree => {
  switch (tree[0]) {
    case "=":
      return `const ${tree[1]} = ${defineVariable(tree[2])};`;
    case "+":
    case "-":
    case "*":
    case "/":
      return insertSymbol(tree);
    case "Function": {
      return defineFunction(tree);
    }
    case "FunctionCall": {
      return `${tree[1]}(${tree.slice(2)})`;
    }
    default:
      return tree.map(x => convertToJS(x)).join("\n");
  }
};

module.exports = convertToJS;
