function loaded(){
   var user = document.getElementsByName("Username");
   user[0].focus();
}
function callMessageGifLogin() {
	window.status = "Loading data, it may take a minute, please wait.....";
	document.LoginForm.submit();
}
function CloseWindow() {
	window.close();
}




