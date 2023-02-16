/**
 * Source: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Errors/Cyclic_object_value
 * Any copyright is dedicated to the Public Domain: https://creativecommons.org/publicdomain/zero/1.0/
 */

const getCircularReplacer = () => {
  const seen = new WeakSet();
  return (_key:any, value:any) => {
    if (typeof value === "object" && value !== null) {
      if (seen.has(value)) {
        return;
      }
      seen.add(value);
    }
    return value;
  };
};

export default getCircularReplacer;