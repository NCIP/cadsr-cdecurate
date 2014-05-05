var runner = require("qunit");
runner.run({
    code : "helpers/mock-gf7680.js;helpers/mock-gf32723.js",
    tests : "units-qun.js"
});