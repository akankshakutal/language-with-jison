const convertToJS = tree => {
  switch (tree[0]) {
    case "=":
      return `const ${tree[1]} = ${tree[2]};`;
    case "*":
      return `${tree[1]} * ${tree[2]}`;
  }
};

module.exports = convertToJS;
