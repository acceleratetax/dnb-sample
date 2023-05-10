
/*
try{
function createPixel(src){
  var input = document.createElement('img');
  input.setAttribute('src',src);
  input.setAttribute('width', 1);
  input.setAttribute('height', 1);
  input.setAttribute('alt', "");
  input.setAttribute('style', "display:none !important;");
  document.body.appendChild(input); 
}

//apn ads - all accounts
if(!!~window.location.href.indexOf("transactionProcessing") || !!~window.location.href.indexOf("transactionprocessing")){
    var oN = document.querySelector("#orderId").textContent; //order id
    var oV = document.cookie.replace(/(?:(?:^|.*;\s*)oV\s*\=\s*([^;]*).*$)|^.*$/, "$1"); 
    createPixel("//secure.adnxs.com/px?id=779615&seg=6708758&order_id="+oN+"&value="+oV+"&other=[USD]&t=2"); //APN Conv Pixel. Replace XXXXXX
}else if(!!~window.location.href.indexOf("dandb.com/product/ecomm/productPurchase") && !!~window.location.href.indexOf("dandb.com/product/ecomm/productPurchase/")){
    createPixel("//secure.adnxs.com/seg?add=5824395&t=2"); //APN Prod Pixel. Replace XXXXXX
	var total = document.querySelector("#orderSummarySubtotalValue").textContent.match(/[0-9.,]+/)[0].replace(",","");
	var d = new Date();
  	d.setTime(d.getTime() + (7200000));
  	var expires = "expires="+d.toGMTString();   
 	document.cookie = "oV=" + total +"; expires=" + expires+"; path=/";
}else if(!!~window.location.href.indexOf("cart.dnb.com/checkout")){
    createPixel("//secure.adnxs.com/seg?add=11237725&t=2"); 
}else if(!!~window.location.href.indexOf("product/credit-reporter") || !!~window.location.href.indexOf("credit-reporter")){
    createPixel("//secure.adnxs.com/seg?add=10978695&t=2"); 
}else if(!!~window.location.href.indexOf("product/credit-builder-premium") || !!~window.location.href.indexOf("credit-builder")){
    createPixel("//secure.adnxs.com/seg?add=10978729&t=2"); 
}else if(!!~window.location.href.indexOf("aff/sbs_a") || !!~window.location.href.indexOf("small-business-starter")){
    createPixel("//secure.adnxs.com/seg?add=11012912&t=2"); 
}else if(!!~window.location.href.indexOf("credit-advisor")){
    createPixel("//secure.adnxs.com/seg?add=11012920&t=2"); 
}else if(!!~window.location.href.indexOf("credit-evaluator-plus")){
    createPixel("//secure.adnxs.com/seg?add=11012921&t=2"); 
}else if(!!~window.location.href.indexOf("international-credit-reports")){
    createPixel("//secure.adnxs.com/seg?add=11012923&t=2"); 
}else if(!!~window.location.href.indexOf("duns-file")){
    createPixel("//secure.adnxs.com/seg?add=17193909&t=2"); 
}else if(!!~window.location.href.indexOf("aff/coo_a") || !!~window.location.href.indexOf("business-information-report")){
    createPixel("//secure.adnxs.com/seg?add=11012925&t=2"); 
}
createPixel("//secure.adnxs.com/seg?add=5824397&t=2"); //APN ROS Pixel. Replace XXXXXX
createPixel("//secure.adnxs.com/seg?add=12312452&t=2");
}catch(e){}