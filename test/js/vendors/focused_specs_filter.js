(function() {
    var inFocusedSuite = false,
        focusedRunnables = [],
        global = jasmine.getGlobal(),
        env = jasmine.getEnv();

    var focusedSuite = function(description, specDefinitions) {
        if(inFocusedSuite) {
            return env.describe(description, specDefinitions);
        }

        inFocusedSuite = true;
        var suite = env.describe(description, specDefinitions);
        inFocusedSuite = false;

        focusedRunnables.push(suite.id);
        return suite;
    };

    var focusedSpec = function(description, func) {
        var spec = env.it(description, func);
        if (!inFocusedSuite) {
            focusedRunnables.push(spec.id);
        }

        return spec;
    };

    describe.only = global.fdescribe = global.ddescribe = global.odescribe = focusedSuite;
    it.only = global.fit = global.iit = global.oit = focusedSpec;

    jasmine.addExecutionFilter(function(specsToRun) {
        return focusedRunnables.length ? focusedRunnables : specsToRun;
    });
})();