if (typeof(cepEnv) == "undefined"){ //Set default env as QA if cepEnv is not defined
	var cepEnv = 'QA';
}

if(cepEnv == 'DEV') {
	document.write('<script type="text/javascript" src="https://ci-mpsnare.iovation.com/snare.js"></script>');
	document.write('<script type="text/javascript" src="http://dbdlerrap01.us.dnb.com:8080/CEP/CepManagedProperties.js"></script>');
}else if(cepEnv == 'QA') {
	document.write('<script type="text/javascript" src="https://ci-mpsnare.iovation.com/snare.js"></script>');
	document.write('<script type="text/javascript" src="http://DBQLERBAPV01.us.dnb.com:8080/CEP/CepManagedProperties.js"></script>');
}else if(cepEnv == 'STG') {
	document.write('<script type="text/javascript" src="https://ci-mpsnare.iovation.com/snare.js"></script>');
	document.write('<script type="text/javascript" src="https://erb-stg.dnb.com/CEP/CepManagedProperties.js"></script>');
}else if(cepEnv == 'STG2') {
	document.write('<script type="text/javascript" src="https://ci-mpsnare.iovation.com/snare.js"></script>');
	document.write('<script type="text/javascript" src="https://eri-stg.dnb.com/CEP/CepManagedProperties.js"></script>');
}else if(cepEnv == 'DR') {
	document.write('<script type="text/javascript" src="https://ci-mpsnare.iovation.com/snare.js"></script>');
	document.write('<script type="text/javascript" src="http://DBRLERBAPV01.us.dnb.com:8080/CEP/CepManagedProperties.js"></script>');
}else if(cepEnv == 'PROD') {
	document.write('<script type="text/javascript" src="https://mpsnare.iesnare.com/snare.js"></script>');
	document.write('<script type="text/javascript" src="https://erb.dnb.com/CEP/CepManagedProperties.js"></script>');
}else if(cepEnv == 'PROD2') {
	document.write('<script type="text/javascript" src="https://mpsnare.iesnare.com/snare.js"></script>');
	document.write('<script type="text/javascript" src="https://eri.dnb.com/CEP/CepManagedProperties.js"></script>');
}

function sendDetailsToCEP(account_code, app_id, event_type_id ,ip_addr,session_id) {
	// iOvation predefined parameters
	var io_install_stm = false; // do not install Active X
	var io_exclude_stm = 12; // do not run Active X
	var io_install_flash = false; // do not install Flash
	var io_enable_rip = true; // collect Real IP information
	// Generate Blackbox
	var bbox = ioGetBlackbox();
	//Post Details to CEP
	if(null == account_code){
		account_code = "";
	}else if(account_code.length == 0){
		account_code = "";
	}else if(account_code == "anonymous"){
		account_code = "";
	}
	
	postToCEP(account_code,app_id,event_type_id,bbox.blackbox,ip_addr,session_id);
}