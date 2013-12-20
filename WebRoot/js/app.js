var App = {};

App.wait = function() {
    document.body.style.cursor = "wait";
}

App.resume = function(){
    document.body.style.cursor = "default";
}

App.sleep = function(seconds) {
    var e = new Date().getTime() + (seconds * 1000);
    while (new Date().getTime() <= e) {}
}