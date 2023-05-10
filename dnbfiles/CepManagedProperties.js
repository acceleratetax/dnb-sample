function postToCEP(account_code, app_id, event_type_id, bbox,ip_addr,session_id) {
	// Generate unique CLIENT_EVENT_TRANS_ID
	var dateString = new Date();
	var date = dateString.getDate();
	var month = dateString.getMonth()+1; //January is 0!
	var year = dateString.getFullYear();
	var hour = dateString.getHours();
	var min = dateString.getMinutes();
	var sec = dateString.getSeconds();
	var ms = dateString.getMilliseconds();
	var cepUrl;
	if(date<10) {
	    date='0'+date;
	} 
	if(month<10) {
	    month='0'+month;
	}
	var clientEventTransIDVal = session_id + '_ERB_' + event_type_id + '_CLIENTEVENTTRANSID_' + date.toString() + '_' + month.toString() + '_' + year.toString() + '_' +
	hour.toString() + '_' + min.toString() + '_' + sec.toString() + '_' + dateString.getMilliseconds();    
	document.getElementById('clientEventTransID').value = clientEventTransIDVal; //Setting clientEventTransID in hidden field
	
	//Logic for cep Servlet URL based on the environment  set
	if(cepEnv == 'DEV') {
		cepUrl = 'http://dbdlerrap01.us.dnb.com:8080/CEP/IUpdateCEPLayer';
	}else if(cepEnv == 'QA') {
		cepUrl = 'http://DBQLERBAPV01.us.dnb.com:8080/CEP/IUpdateCEPLayer';
	}else if(cepEnv == 'STG') {
		cepUrl = 'https://erb-stg.dnb.com/CEP/IUpdateCEPLayer';
	}else if(cepEnv == 'STG2') {
		cepUrl = 'https://eri-stg.dnb.com/CEP/IUpdateCEPLayer';
	}else if(cepEnv == 'DR') {
		cepUrl = 'http://DBRLERBAPV01.us.dnb.com:8080/CEP/IUpdateCEPLayer';
	}else if(cepEnv == 'PROD') {
		cepUrl = 'https://erb.dnb.com/CEP/IUpdateCEPLayer';
	}else if(cepEnv == 'PROD2') {
		cepUrl = 'https://eri.dnb.com/CEP/IUpdateCEPLayer';
	}
	
	try {
	xdr = new XDomainRequest();//For Internet Explorer
	xdr.open("POST", cepUrl);
	xdr.send("browserFlag=IE&client_event_trans_id=" + clientEventTransIDVal + "&account_code="
			+ account_code + "&app_id=" + app_id + "&ip_addr=" + ip_addr + "&session_id=" + session_id + "&event_type_id="
			+ event_type_id + "&blackbox=" + bbox);
	} catch (e) {
		//Send AJAX Request to CEP Servlet
		var deviceAuthXmHttp;
		if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome,
			// Opera, Safari
			deviceAuthXmHttp = new XMLHttpRequest();
		} else {// code for IE6, IE5
			deviceAuthXmHttp = new ActiveXObject("Microsoft.XMLHTTP");
		}
		deviceAuthXmHttp.open("POST", cepUrl, false);
		deviceAuthXmHttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		deviceAuthXmHttp.send("browserFlag=OTHER&client_event_trans_id=" + clientEventTransIDVal + "&account_code="
				+ account_code + "&app_id=" + app_id + "&ip_addr=" + ip_addr + "&session_id=" + session_id + "&event_type_id="
				+ event_type_id + "&blackbox=" + bbox);
	}
}



function setButtonClickRequest(account_code, app_id, event_type_id, ip_addr,session_id){
	// iOvation predefined parameters - do not change
	var io_install_stm = false; // do not install Active X
	var io_exclude_stm = 12; // do not run Active X
	var io_install_flash = false; // do not install Flash
	var io_enable_rip = true; // collect Real IP information
	
	
	// Generate unique CLIENT_EVENT_TRANS_ID
	var dateString = new Date();
	var date = dateString.getDate();
	var month = dateString.getMonth()+1; //January is 0!
	var year = dateString.getFullYear();
	var hour = dateString.getHours();
	var min = dateString.getMinutes();
	var sec = dateString.getSeconds();
	var ms = dateString.getMilliseconds();
	var bbox = ioGetBlackbox();
	if(date<10) {
	    date='0'+date;
	} 
	if(month<10) {
	    month='0'+month;
	}

	var clientEventTransIDVal = session_id + '_ERB_' + event_type_id + '_CLIENTEVENTTRANSID_' + date.toString() + '_' + month.toString() + '_' + year.toString() + '_' +
	hour.toString() + '_' + min.toString() + '_' + sec.toString() + '_' + dateString.getMilliseconds();    
	document.getElementById('clientEventTransID').value = clientEventTransIDVal; //Setting clientEventTransID in hidden field
	
	var cepRequestVal = "browserFlag=NA&client_event_trans_id=" + clientEventTransIDVal + "&account_code="
	+ account_code + "&app_id=" + app_id + "&ip_addr=" + ip_addr + "&session_id=" + session_id + "&event_type_id="
	+ event_type_id + "&blackbox=" + bbox.blackbox;

	document.getElementById('cepRequestString').value = cepRequestVal; //Setting cepRequestString in hidden field
}