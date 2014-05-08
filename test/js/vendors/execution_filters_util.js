(function() {
    var executionFilters = [];

    jasmine.addExecutionFilter = function(filter) {
        executionFilters.push(filter);
    };

    jasmine.customExecute = function() {
        var specsToExecute = [jasmine.getEnv().topSuite().id];
        for (var i = 0; i < executionFilters.length; i++) {
            var filter = executionFilters[i];
            specsToExecute = filter(specsToExecute);
        }

        jasmine.getEnv().execute(specsToExecute);
    };
})();