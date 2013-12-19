var App = {};

App.wait = function() {
    document.body.style.cursor = "wait";
}

App.resume = function(){
    document.body.style.cursor = "default";
}
