function omitKeys(obj, keys) {
    var dup = {};
    for (var key in obj) {
        if (keys.indexOf(key) == -1) {
            dup[key] = obj[key];
        }
    }
    return dup;
}

var x = {
    x: {
        a: 1
    },
    y: 0,
    divID: "xyz",
    privateProperty1: 'foo',
    privateProperty2: 'bar'
};

console.log(JSON.stringify(omitKeys(x, ['privateProperty1', 'privateProperty2'])));