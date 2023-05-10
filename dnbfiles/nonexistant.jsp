if (typeof usi_dom === 'undefined') {
    usi_dom = {};
    usi_dom.get_elements = function(selector, element) {
        var elements = [];
        element = (element || document);
        elements = Array.prototype.slice.call(element.querySelectorAll(selector));
        return elements;
    };
    usi_dom.count_elements = function(selector, element) {
        element = (element || document);
        return usi_dom.get_elements(selector, element).length;
    };
    usi_dom.get_nth_element = function(ordinal, selector, element) {
        var nthElement = null;
        element = (element || document);
        var elements = usi_dom.get_elements(selector, element);
        if (elements.length >= ordinal) {
            nthElement = elements[ordinal - 1];
        }
        return nthElement;
    };
    usi_dom.get_first_element = function(selector, element) {
        if ((selector || '') === '') {
            return null;
        }
        element = (element || document);
        if (Object.prototype.toString.call(selector) === '[object Array]') {
            var selectedElement = null;
            for (var selectorIndex = 0; selectorIndex < selector.length; selectorIndex++) {
                var selectorItem = selector[selectorIndex];
                selectedElement = usi_dom.get_first_element(selectorItem, element);
                if (selectedElement != null) {
                    break;
                }
            }
            return selectedElement;
        } else {
            return element.querySelector(selector);
        }
    };
    usi_dom.get_element_text_no_children = function(element, doCleanString) {
        var content = '';
        if (doCleanString == null) {
            doCleanString = false;
        }
        element = (element || document);
        if (element != null && element.childNodes != null) {
            for (var i = 0; i < element.childNodes.length; ++i) {
                if (element.childNodes[i].nodeType === 3) {
                    content += element.childNodes[i].textContent;
                }
            }
        }
        if (doCleanString === true) {
            content = usi_dom.clean_string(content);
        }
        return content.trim();
    };
    usi_dom.clean_string = function(content) {
        if (typeof content !== 'string') {
            return;
        }
        content = content.replace(/[\u2010-\u2015\u2043]/g, '-');
        content = content.replace(/[\u2018-\u201B]/g, "'");
        content = content.replace(/[\u201C-\u201F]/g, '"');
        content = content.replace(/\u2024/g, '.');
        content = content.replace(/\u2025/g, '..');
        content = content.replace(/\u2026/g, '...');
        content = content.replace(/\u2044/g, '/');
        var nonAsciiChars = /[^\x20-\xFF\u0100-\u017F\u0180-\u024F\u20A0-\u20CF]/g;
        return content.replace(nonAsciiChars, '').trim();
    };
    usi_dom.encode = function(content) {
        if (typeof content !== 'string') {
            return;
        }
        var encodedContent = encodeURIComponent(content);
        encodedContent = encodedContent.replace(/[-_.!~*'()]/g, function(r) {
            return '%' + r.charCodeAt(0).toString(16).toUpperCase();
        });
        return encodedContent;
    };
    usi_dom.get_closest = function(element, selector) {
        element = (element || document);
        if (typeof Element.prototype.matches !== 'function') {
            Element.prototype.matches =
                Element.prototype.matchesSelector ||
                Element.prototype.mozMatchesSelector ||
                Element.prototype.msMatchesSelector ||
                Element.prototype.oMatchesSelector ||
                Element.prototype.webkitMatchesSelector ||
                function(s) {
                    var matches = (this.document || this.ownerDocument).querySelectorAll(s);
                    var matchIndex = matches.length;
                    while (--matchIndex >= 0 && matches.item(matchIndex) !== this) {}
                    return matchIndex > -1;
                };
        }
        for (; element != null && element !== document; element = element.parentNode) {
            if (element.matches(selector)) {
                return element;
            }
        }
        return null;
    };
    usi_dom.get_classes = function(element) {
        var classes = [];
        if (element != null && element.classList != null) {
            classes = Array.prototype.slice.call(element.classList);
        }
        return classes;
    };
    usi_dom.add_class = function(element, className) {
        if (element != null) {
            var classes = usi_dom.get_classes(element);
            if (classes.indexOf(className) === -1) {
                classes.push(className);
                element.className = classes.join(' ');
            }
        }
    };
    usi_dom.string_to_decimal = function(stringContent) {
        var decimalValue = null;
        if (typeof stringContent === 'string') {
            try {
                var testValue = parseFloat(stringContent.replace(/[^0-9\.-]+/g, ''));
                if (isNaN(testValue) === false) {
                    decimalValue = testValue;
                }
            } catch (err) {
                usi_commons.log('Error: ' + err.message);
            }
        }
        return decimalValue;
    };
    usi_dom.string_to_integer = function(stringContent) {
        var integerValue = null;
        if (typeof stringContent === 'string') {
            try {
                var testValue = parseInt(stringContent.replace(/[^0-9-]+/g, ''));
                if (isNaN(testValue) === false) {
                    integerValue = testValue;
                }
            } catch (err) {
                usi_commons.log('Error: ' + err.message);
            }
        }
        return integerValue;
    };
    usi_dom.get_currency_string_from_content = function(stringContent) {
        if (typeof stringContent !== 'string') {
            return '';
        }
        try {
            stringContent = stringContent.trim();
            var currencyPattern = /^([^$]*?)($(?:[\,\,]?\d{1,3})+(?:\.\d{2})?)(.*?)$/;
            var currencyMatches = (stringContent.match(currencyPattern) || []);
            if (currencyMatches.length === 4) {
                return currencyMatches[2];
            } else {
                return '';
            }
        } catch (err) {
            usi_commons.log('Error: ' + err.message);
            return '';
        }
    };
    usi_dom.get_absolute_url = (function() {
        var a;
        return function(url) {
            a = (a || document.createElement('a'));
            a.href = url;
            return a.href;
        };
    })();
    usi_dom.format_number = function(number, decimalPlaces) {
        var formattedNumber = '';
        if (typeof number === 'number') {
            decimalPlaces = (decimalPlaces || 0);
            var workingNumber = number.toFixed(decimalPlaces);
            var numberParts = workingNumber.split(/\./g);
            if (numberParts.length == 1 || numberParts.length == 2) {
                var numberPortion = numberParts[0];
                formattedNumber = numberPortion.replace(/./g, function(c, i, a) {
                    return i && c !== '.' && ((a.length - i) % 3 === 0) ? ',' + c : c;
                });
                if (numberParts.length == 2) {
                    formattedNumber += '.' + numberParts[1];
                }
            }
        }
        return formattedNumber;
    };
    usi_dom.format_currency = function(number, languageCode, options) {
        var formattedCurrency = '';
        number = Number(number);
        if (isNaN(number) === false) {
            if (typeof Intl == 'object' && typeof Intl.NumberFormat == 'function') {
                languageCode = languageCode || 'en-US';
                options = options || {
                    style: 'currency',
                    currency: 'USD'
                };
                formattedCurrency = number.toLocaleString(languageCode, options);
            } else {
                formattedCurrency = number;
            }
        }
        return formattedCurrency;
    };
    usi_dom.to_decimal_places = function(numberValue, decimalPlaces) {
        if (numberValue != null && typeof numberValue === 'number' && decimalPlaces != null && typeof decimalPlaces === 'number') {
            if (decimalPlaces == 0) {
                return parseFloat(Math.round(numberValue));
            }
            var multiplier = 10;
            for (var i = 1; i < decimalPlaces; i++) {
                multiplier *= 10;
            }
            return parseFloat(Math.round(numberValue * multiplier) / multiplier);
        } else {
            return null;
        }
    };
    usi_dom.trim_string = function(stringValue, maxLength, trimmedText) {
        stringValue = (stringValue || '');
        trimmedText = (trimmedText || '');
        if (stringValue.length > maxLength) {
            stringValue = stringValue.substring(0, maxLength);
            if (trimmedText !== '') {
                stringValue += trimmedText;
            }
        }
        return stringValue;
    };
    usi_dom.attach_event = function(eventName, func, element) {
        var attachToElement = usi_dom.find_supported_element(eventName, element);
        usi_dom.detach_event(eventName, func, attachToElement);
        if (attachToElement.addEventListener) {
            attachToElement.addEventListener(eventName, func, false);
        } else {
            attachToElement.attachEvent('on' + eventName, func);
        }
    };
    usi_dom.detach_event = function(eventName, func, element) {
        var removeFromElement = usi_dom.find_supported_element(eventName, element);
        if (removeFromElement.removeEventListener) {
            removeFromElement.removeEventListener(eventName, func, false);
        } else {
            removeFromElement.detachEvent('on' + eventName, func);
        }
    };
    usi_dom.find_supported_element = function(eventName, element) {
        element = (element || document);
        if (element === window) {
            return window;
        } else if (usi_dom.is_event_supported(eventName, element) === true) {
            return element;
        } else {
            if (element === document) {
                return window;
            } else {
                return usi_dom.find_supported_element(eventName, document);
            }
        }
    };
    usi_dom.is_event_supported = function(eventName, element) {
        return (element != null && typeof element['on' + eventName] !== 'undefined');
    };
    usi_dom.is_defined = function(testObj, propertyPath) {
        if (testObj == null) {
            return false;
        }
        if ((propertyPath || '') === '') {
            return false;
        }
        var isDefined = true;
        var currentObj = testObj;
        var properties = propertyPath.split('.');
        properties.forEach(function(propertyName) {
            if (isDefined === true) {
                if (currentObj == null || typeof currentObj !== 'object' || currentObj.hasOwnProperty(propertyName) === false) {
                    isDefined = false;
                } else {
                    currentObj = currentObj[propertyName];
                }
            }
        });
        return isDefined;
    };
    usi_dom.observe = (function(element, options, callback) {
        var url = location.href;
        var defaultOptions = {
            onUrlUpdate: false,
            observerOptions: {
                childList: true,
                subtree: true
            }
        };
        var MutationObserver = window.MutationObserver || window.WebkitMutationObserver;
        options = options || defaultOptions;
        return function(element, callback) {
            var observer = null;
            var callbackHandler = function() {
                var currentUrl = location.href;
                if (options.onUrlUpdate && currentUrl !== url) {
                    callback();
                    url = currentUrl;
                } else {
                    callback();
                }
            };
            if (MutationObserver) {
                observer = new MutationObserver(function(mutations) {
                    var currentUrl = location.href;
                    var hasMutations = mutations[0].addedNodes.length || mutations[0].removedNodes.length;
                    if (hasMutations && options.onUrlUpdate && currentUrl !== url) {
                        callback();
                        url = currentUrl;
                    } else if (hasMutations) {
                        callback();
                    }
                });
                observer.observe(element, options.observerOptions);
            } else if (window.addEventListener) {
                element.addEventListener('DOMNodeInserted', callbackHandler, false);
                element.addEventListener('DOMNodeRemoved', callbackHandler, false);
            }
            return observer;
        };
    })();
    usi_dom.params_to_object = function(paramsString) {
        var paramsObj = {};
        if ((paramsString || '') != '') {
            var params = paramsString.split('&');
            params.forEach(function(param) {
                var paramParts = param.split('=');
                if (paramParts.length === 2) {
                    paramsObj[decodeURIComponent(paramParts[0])] = decodeURIComponent(paramParts[1]);
                } else if (paramParts.length === 1) {
                    paramsObj[decodeURIComponent(paramParts[0])] = null;
                }
            });
        }
        return paramsObj;
    };
    usi_dom.object_to_params = function(obj) {
        var params = [];
        if (obj != null) {
            for (var key in obj) {
                if (obj.hasOwnProperty(key) === true) {
                    params.push(encodeURIComponent(key) + '=' + (obj[key] == null ? '' : encodeURIComponent(obj[key])));
                }
            }
        }
        return params.join('&');
    };
    usi_dom.interval_with_timeout = function(iterationFunction, timeoutCallback, completeCallback, options) {
        if (typeof iterationFunction !== 'function') {
            throw new Error('usi_dom.interval_with_timeout(): iterationFunction must be a function');
        }
        if (timeoutCallback == null) {
            timeoutCallback = function(timeoutResult) {
                return timeoutResult;
            }
        } else if (typeof timeoutCallback !== 'function') {
            throw new Error('usi_dom.interval_with_timeout(): timeoutCallback must be a function');
        }
        if (completeCallback == null) {
            completeCallback = function(completeResult) {
                return completeResult;
            }
        } else if (typeof completeCallback !== 'function') {
            throw new Error('usi_dom.interval_with_timeout(): completeCallback must be a function');
        }
        options = (options || {});
        var intervalMS = (options.intervalMS || 20);
        var timeoutMS = (options.timeoutMS || 2000);
        if (typeof intervalMS !== 'number') {
            throw new Error('usi_dom.interval_with_timeout(): intervalMS must be a number');
        }
        if (typeof timeoutMS !== 'number') {
            throw new Error('usi_dom.interval_with_timeout(): timeoutMS must be a number');
        }
        var completionIsRunning = false;
        var intervalStartDate = new Date();
        var interval = setInterval(function() {
            var elapsedMS = ((new Date()) - intervalStartDate);
            if (elapsedMS >= timeoutMS) {
                clearInterval(interval);
                var timeoutResult = {
                    elapsedMS: elapsedMS
                };
                return timeoutCallback(timeoutResult);
            } else {
                if (completionIsRunning === false) {
                    completionIsRunning = true;
                    iterationFunction(function(isComplete, completeResult) {
                        completionIsRunning = false;
                        if (isComplete === true) {
                            clearInterval(interval);
                            completeResult = (completeResult || {});
                            completeResult.elapsedMS = ((new Date()) - intervalStartDate);
                            return completeCallback(completeResult);
                        }
                    });
                }
            }
        }, intervalMS);
    };
    usi_dom.load_external_stylesheet = function(url, id, callback) {
        if ((url || '') !== '') {
            if ((id || '') === '') {
                id = 'usi_stylesheet_' + ((new Date()).getTime());
            }
            var result = {
                url: url,
                id: id
            };
            var headElement = document.getElementsByTagName("head")[0];
            if (headElement != null) {
                var linkElement = document.createElement('link');
                linkElement.type = 'text/css';
                linkElement.rel = 'stylesheet';
                linkElement.id = result.id;
                linkElement.href = url;
                usi_dom.attach_event('load', function() {
                    if (callback != null) {
                        return callback(null, result);
                    }
                }, linkElement);
                headElement.appendChild(linkElement);
            }
        } else {
            if (callback != null) {
                return callback(null, result);
            }
        }
    };
    usi_dom.ready = function(callback) {
        if (typeof (document.readyState) != "undefined" && document.readyState === "complete") {
            callback();
        } else if (window.addEventListener) {
            window.addEventListener('load', callback, true);
        } else if (window["attachEvent"]) {
            window["attachEvent"]('onload', callback);
        } else {
            setTimeout(callback, 5000);
        }
    };
    usi_dom.fit_text = function (els, options) {
        if (!options) options = {};
        var defaultSettings = {
            multiLine: true,
            minFontSize: 0.1,
            maxFontSize: 20,
            widthOnly: false,
        };
        var settings = {};
        for(var key in defaultSettings){
            if(options.hasOwnProperty(key)){
                settings[key] = options[key];
            } else {
                settings[key] = defaultSettings[key];
            }
        }
        var elType = Object.prototype.toString.call(els);
        if (elType !== '[object Array]' && elType !== '[object NodeList]' &&
            elType !== '[object HTMLCollection]'){
            els = [els];
        }
        function processItem(el, settings){
            var innerSpan, originalHeight, originalHTML, originalWidth, originalFontSize;
            var low, mid, high;
            function innerHeight(el){
                var style = window.getComputedStyle(el, null);
                return (el.clientHeight -
                    parseInt(style.getPropertyValue('padding-top'), 10) -
                    parseInt(style.getPropertyValue('padding-bottom'), 10)) / originalFontSize;
            }
            function innerWidth(el){
                var style = window.getComputedStyle(el, null);
                return (el.clientWidth -
                    parseInt(style.getPropertyValue('padding-left'), 10) -
                    parseInt(style.getPropertyValue('padding-right'), 10)) / originalFontSize;
            }
            originalHTML = el.innerHTML;
            originalFontSize = parseInt(window.getComputedStyle(el, null).getPropertyValue('font-size'), 10);
            originalWidth = innerWidth(el);
            originalHeight = innerHeight(el);
            if (!originalWidth || (!settings.widthOnly && !originalHeight)) {
                if (!settings.widthOnly) usi_commons.log('Set a static height and width on the target element ' + el.outerHTML);
                else usi_commons.log('Set a static width on the target element ' + el.outerHTML);
            }
            if (originalHTML.indexOf('textFitted') === -1) {
                innerSpan = document.createElement('span');
                innerSpan.className = 'textFitted';
                innerSpan.style['display'] = 'inline-block';
                innerSpan.innerHTML = originalHTML;
                el.innerHTML = '';
                el.appendChild(innerSpan);
            } else {
                innerSpan = el.querySelector('span.textFitted');
            }
            if (!settings.multiLine) {
                el.style['white-space'] = 'nowrap';
            }
            low = settings.minFontSize;
            high = settings.maxFontSize;
            var size = low;
            var max_loops = 1000;
            while (low <= high && max_loops > 0) {
                max_loops--;
                mid = (high + low) - 0.1;
                innerSpan.style.fontSize = mid + 'em';
                if ((innerSpan.scrollWidth / originalFontSize) <= originalWidth && (settings.widthOnly || (innerSpan.scrollHeight / originalFontSize) <= originalHeight)){
                    size = mid;
                    low = mid + 0.1;
                } else {
                    high = mid - 0.1;
                }
            }
            if (innerSpan.style.fontSize !== size + 'em') innerSpan.style.fontSize = size + 'em';
        }
        for(var i = 0; i < els.length; i++){
            processItem(els[i], settings);
        }
    };
}Array.prototype.filter||(Array.prototype.filter=function(t,e){"use strict";if("Function"!=typeof t&&"function"!=typeof t||!this)throw new TypeError;var r=this.length>>>0,o=new Array(r),n=this,l=0,i=-1;if(void 0===e)for(;++i!==r;)i in this&&t(n[i],i,n)&&(o[l++]=n[i]);else for(;++i!==r;)i in this&&t.call(e,n[i],i,n)&&(o[l++]=n[i]);return o.length=l,o}),Array.prototype.forEach||(Array.prototype.forEach=function(t){var e,r;if(null==this)throw new TypeError('"this" is null or not defined');var o=Object(this),n=o.length>>>0;if("function"!=typeof t)throw new TypeError(t+" is not a function");for(arguments.length>1&&(e=arguments[1]),r=0;r<n;){var l;r in o&&(l=o[r],t.call(e,l,r,o)),r++}}),window.NodeList&&!NodeList.prototype.forEach&&(NodeList.prototype.forEach=Array.prototype.forEach),Array.prototype.indexOf||(Array.prototype.indexOf=function(t,e){var r;if(null==this)throw new TypeError('"this" is null or not defined');var o=Object(this),n=o.length>>>0;if(0===n)return-1;var l=0|e;if(l>=n)return-1;for(r=Math.max(l>=0?l:n-Math.abs(l),0);r<n;){if(r in o&&o[r]===t)return r;r++}return-1}),document.getElementsByClassName||(document.getElementsByClassName=function(t){var e,r,o,n=document,l=[];if(n.querySelectorAll)return n.querySelectorAll("."+t);if(n.evaluate)for(r=".//*[contains(concat(' ', @class, ' '), ' "+t+" ')]",e=n.evaluate(r,n,null,0,null);o=e.iterateNext();)l.push(o);else for(e=n.getElementsByTagName("*"),r=new RegExp("(^|\\s)"+t+"(\\s|$)"),o=0;o<e.length;o++)r.test(e[o].className)&&l.push(e[o]);return l}),document.querySelectorAll||(document.querySelectorAll=function(t){var e,r=document.createElement("style"),o=[];for(document.documentElement.firstChild.appendChild(r),document._qsa=[],r.styleSheet.cssText=t+"{x-qsa:expression(document._qsa && document._qsa.push(this))}",window.scrollBy(0,0),r.parentNode.removeChild(r);document._qsa.length;)(e=document._qsa.shift()).style.removeAttribute("x-qsa"),o.push(e);return document._qsa=null,o}),document.querySelector||(document.querySelector=function(t){var e=document.querySelectorAll(t);return e.length?e[0]:null}),Object.keys||(Object.keys=function(){"use strict";var t=Object.prototype.hasOwnProperty,e=!{toString:null}.propertyIsEnumerable("toString"),r=["toString","toLocaleString","valueOf","hasOwnProperty","isPrototypeOf","propertyIsEnumerable","constructor"],o=r.length;return function(n){if("function"!=typeof n&&("object"!=typeof n||null===n))throw new TypeError("Object.keys called on non-object");var l,i,s=[];for(l in n)t.call(n,l)&&s.push(l);if(e)for(i=0;i<o;i++)t.call(n,r[i])&&s.push(r[i]);return s}}()),"function"!=typeof String.prototype.trim&&(String.prototype.trim=function(){return this.replace(/^\s+|\s+$/g,"")}),String.prototype.replaceAll||(String.prototype.replaceAll=function(t,e){return"[object regexp]"===Object.prototype.toString.call(t).toLowerCase()?this.replace(t,e):this.replace(new RegExp(t,"g"),e)}),window.hasOwnProperty=window.hasOwnProperty||Object.prototype.hasOwnProperty;
if (typeof usi_commons === 'undefined') {
	usi_commons = {
		
		debug: location.href.indexOf("usidebug") != -1 || location.href.indexOf("usi_debug") != -1,
		
		log:function(msg) {
			if (usi_commons.debug) {
				try {
					if (msg instanceof Error) {
						console.log(msg.name + ': ' + msg.message);
					} else {
						console.log.apply(console, arguments);
					}
				} catch(err) {
					usi_commons.report_error_no_console(err);
				}
			}
		},
		log_error: function(msg) {
			if (usi_commons.debug) {
				try {
					if (msg instanceof Error) {
						console.log('%c USI Error:', usi_commons.log_styles.error, msg.name + ': ' + msg.message);
					} else {
						console.log('%c USI Error:', usi_commons.log_styles.error, msg);
					}
				} catch(err) {
					usi_commons.report_error_no_console(err);
				}
			}
		},
		log_success: function(msg) {
			if (usi_commons.debug) {
				try {
					console.log('%c USI Success:', usi_commons.log_styles.success, msg);
				} catch(err) {
					usi_commons.report_error_no_console(err);
				}
			}
		},
		dir:function(obj) {
			if (usi_commons.debug) {
				try {
					console.dir(obj);
				} catch(err) {
					usi_commons.report_error_no_console(err);
				}
			}
		},
		log_styles: {
			error: 'color: red; font-weight: bold;',
			success: 'color: green; font-weight: bold;'
		},
		domain: "https://app.upsellit.com",
		cdn: "https://www.upsellit.com",
		is_mobile: (/iphone|ipod|ipad|android|blackberry|mobi/i).test(navigator.userAgent.toLowerCase()),
		device: (/iphone|ipod|ipad|android|blackberry|mobi/i).test(navigator.userAgent.toLowerCase()) ? 'mobile' : 'desktop',
		gup:function(name) {
			try {
				name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
				var regexS = "[\\?&]" + name + "=([^&#\\?]*)";
				var regex = new RegExp(regexS);
				var results = regex.exec(window.location.href);
				if (results == null) return "";
				else return results[1];
			} catch (e) {
				usi_commons.report_error(e);
			}
		},
		load_script:function(source, callback, nocache) {
			try {
				if (source.indexOf("//www.upsellit.com") == 0) source = "https:"+source; //upgrade non-secure requests
				var docHead = document.getElementsByTagName("head")[0];
				if (top.location != location) docHead = parent.document.getElementsByTagName("head")[0];
				var newScript = document.createElement('script');
				newScript.type = 'text/javascript';
				var usi_appender = "";
				if (!nocache && source.indexOf("/active/") == -1 && source.indexOf("_pixel.jsp") == -1 && source.indexOf("_throttle.jsp") == -1 && source.indexOf("metro") == -1 && source.indexOf("_suppress") == -1 && source.indexOf("product_recommendations.jsp") == -1 && source.indexOf("_pid.jsp") == -1 && source.indexOf("_zips") == -1) {
					usi_appender = (source.indexOf("?")==-1?"?":"&");
					if (source.indexOf("pv2.js") != -1) usi_appender = "%7C";
					usi_appender += "si=" + usi_commons.get_sess();
				}
				newScript.src = source + usi_appender;
				if (typeof callback == "function") {
					newScript.onload = function() {
						try {
							callback();
						} catch (e) {
							usi_commons.report_error(e);
						}
					};
				}
				docHead.appendChild(newScript);
			} catch (e) {
				usi_commons.report_error(e);
			}
		},
		load_display:function(usiQS, usiSiteID, usiKey, callback) {
			try {
				usiKey = usiKey || "";
				var source = usi_commons.domain + "/launch.jsp?qs=" + usiQS + "&siteID=" + usiSiteID + "&keys=" + usiKey;
				usi_commons.load_script(source, callback);
			} catch (e) {
				usi_commons.report_error(e);
			}
		},
		load_view:function(usiHash, usiSiteID, usiKey, callback) {
			try {
				if (typeof(usi_force) != "undefined" || location.href.indexOf("usi_force") != -1 || (usi_cookies.get("usi_sale") == null && usi_cookies.get("usi_launched") == null && usi_cookies.get("usi_launched"+usiSiteID) == null)) {
					usiKey = usiKey || "";
					var usi_append = "";
					if (usi_commons.gup("usi_force_date") != "") usi_append = "&usi_force_date=" + usi_commons.gup("usi_force_date");
					else if (typeof usi_cookies !== 'undefined' && usi_cookies.get("usi_force_date") != null) usi_append = "&usi_force_date=" + usi_cookies.get("usi_force_date");
					if (usi_commons.debug) usi_append += "&usi_referrer="+encodeURIComponent(location.href);
					var source = usi_commons.domain + "/view.jsp?hash=" + usiHash + "&siteID=" + usiSiteID + "&keys=" + usiKey + usi_append;
					if (typeof(usi_commons.last_view) !== "undefined" && usi_commons.last_view == usiSiteID+"_"+usiKey) return;
					usi_commons.last_view = usiSiteID+"_"+usiKey;
					if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') usi_js.cleanup();
					usi_commons.load_script(source, callback);
				}
			} catch (e) {
				usi_commons.report_error(e);
			}
		},
		remove_loads:function() {
			try {
				if (document.getElementById("usi_obj") != null) {
					document.getElementById("usi_obj").parentNode.parentNode.removeChild(document.getElementById("usi_obj").parentNode);
				}
				if (typeof(usi_commons.usi_loads) !== "undefined") {
					for (var i in usi_commons.usi_loads) {
						if (document.getElementById("usi_"+i) != null) {
							document.getElementById("usi_"+i).parentNode.parentNode.removeChild(document.getElementById("usi_"+i).parentNode);
						}
					}
				}
			} catch (e) {
				usi_commons.report_error(e);
			}
		},
		load:function(usiHash, usiSiteID, usiKey, callback){
			try {
				if (typeof(window["usi_" + usiSiteID]) !== "undefined") return;
				usiKey = usiKey || "";
				var usi_append = "";
				if (usi_commons.gup("usi_force_date") != "") usi_append = "&usi_force_date=" + usi_commons.gup("usi_force_date");
				else if (typeof usi_cookies !== 'undefined' && usi_cookies.get("usi_force_date") != null) usi_append = "&usi_force_date=" + usi_cookies.get("usi_force_date");
				if (usi_commons.debug) usi_append += "&usi_referrer="+encodeURIComponent(location.href);
				var source = usi_commons.domain + "/usi_load.jsp?hash=" + usiHash + "&siteID=" + usiSiteID + "&keys=" + usiKey + usi_append;
				usi_commons.load_script(source, callback);
				if (typeof(usi_commons.usi_loads) === "undefined") {
					usi_commons.usi_loads = {};
				}
				usi_commons.usi_loads[usiSiteID] = usiSiteID;
			} catch (e) {
				usi_commons.report_error(e);
			}
		},
		load_precapture:function(usiQS, usiSiteID, callback) {
			try {
				if (typeof(usi_commons.last_precapture_siteID) !== "undefined" && usi_commons.last_precapture_siteID == usiSiteID) return;
				usi_commons.last_precapture_siteID = usiSiteID;
				var source = usi_commons.domain + "/hound/monitor.jsp?qs=" + usiQS + "&siteID=" + usiSiteID;
				usi_commons.load_script(source, callback);
			} catch (e) {
				usi_commons.report_error(e);
			}
		},
		load_mail:function(qs, siteID, callback) {
			try {
				var source = usi_commons.domain + "/mail.jsp?qs=" + qs + "&siteID=" + siteID + "&domain=" + encodeURIComponent(usi_commons.domain);
				usi_commons.load_script(source, callback);
			} catch (e) {
				usi_commons.report_error(e);
			}
		},
		load_products:function(options) {
			try {
				if (!options.siteID || !options.pid) return;
				var queryStr = "";
				var params = ['siteID', 'association_siteID', 'pid', 'less_expensive', 'rows', 'days_back', 'force_exact', 'match', 'nomatch', 'name_from', 'image_from', 'price_from', 'url_from', 'extra_from', 'custom_callback', 'allow_dupe_names', 'expire_seconds', 'name'];
				params.forEach(function(name, index){
					if (options[name]) {
						queryStr += (index == 0 ? "?" : "&") + name + '=' + options[name];
					}
				});
				if (options.filters) {
					queryStr += "&filters=" + encodeURIComponent(options.filters.join("&"));
				}
				usi_commons.load_script(usi_commons.cdn + '/utility/product_recommendations_filter.jsp' + queryStr, function(){
					if (typeof options.callback === 'function') {
						options.callback();
					}
				});
			} catch (e) {
				usi_commons.report_error(e);
			}
		},
		send_prod_rec:function(siteID, info, real_time) {
			var result = false;
			try {
				if (document.getElementsByTagName("html").length > 0 && document.getElementsByTagName("html")[0].className != null && document.getElementsByTagName("html")[0].className.indexOf("translated") != -1) {
					//Ignore translated pages
					return false;
				}
				var data = [siteID, info.name, info.link, info.pid, info.price, info.image];
				if (data.indexOf(undefined) == -1) {
					var queryString = [siteID, info.name.replace(/\|/g, "&#124;"), info.link, info.pid, info.price, info.image].join("|") + "|";
					if (info.extra) queryString += info.extra + "|";
					var filetype = real_time ? "jsp" : "js";
					usi_commons.load_script(usi_commons.domain + "/utility/pv2." + filetype + "?" + encodeURIComponent(queryString));
					result = true;
				}
			} catch (e) {
				usi_commons.report_error(e);
				result = false;
			}
			return result;
		},
		report_error:function(err) {
			if (err == null) return;
			if (typeof err === 'string') err = new Error(err);
			if (!(err instanceof Error)) return;
			if (typeof(usi_commons.error_reported) !== "undefined") {
				return;
			}
			usi_commons.error_reported = true;
			if (location.href.indexOf('usishowerrors') !== -1) throw err;
			else usi_commons.load_script(usi_commons.domain + '/err.jsp?oops=' + encodeURIComponent(err.message) + '-' + encodeURIComponent(err.stack) + "&url=" + encodeURIComponent(location.href));
			usi_commons.log_error(err.message);
			usi_commons.dir(err);
		},
		report_error_no_console:function(err) {
			if (err == null) return;
			if (typeof err === 'string') err = new Error(err);
			if (!(err instanceof Error)) return;
			if (typeof(usi_commons.error_reported) !== "undefined") {
				return;
			}
			usi_commons.error_reported = true;
			if (location.href.indexOf('usishowerrors') !== -1) throw err;
			else usi_commons.load_script(usi_commons.domain + '/err.jsp?oops=' + encodeURIComponent(err.message) + '-' + encodeURIComponent(err.stack) + "&url=" + encodeURIComponent(location.href));
		},
		gup_or_get_cookie: function(name, expireSeconds, forceCookie) {
			try {
				if (typeof usi_cookies === 'undefined') {
					usi_commons.log_error('usi_cookies is not defined');
					return;
				}
				expireSeconds = (expireSeconds || usi_cookies.expire_time.day);
				if (name == "usi_enable") expireSeconds = usi_cookies.expire_time.hour;
				var value = null;
				var qsValue = usi_commons.gup(name);
				if (qsValue !== '') {
					value = qsValue;
					usi_cookies.set(name, value, expireSeconds, forceCookie);
				} else {
					value = usi_cookies.get(name);
				}
				return (value || '');
			} catch (e) {
				usi_commons.report_error(e);
			}
		},
		get_sess: function() {
			var usi_si = null;
			if (typeof(usi_cookies) === "undefined") return "";
			try {
				if (usi_cookies.get('usi_si') == null) {
					var usi_rand_str = Math.random().toString(36).substring(2);
					if (usi_rand_str.length > 6) usi_rand_str = usi_rand_str.substring(0, 6);
					usi_si = usi_rand_str + "_" + Math.round((new Date()).getTime() / 1000);
					usi_cookies.set('usi_si', usi_si, 24*60*60);
					return usi_si;
				}
				if (usi_cookies.get('usi_si') != null) usi_si = usi_cookies.get('usi_si');
				usi_cookies.set('usi_si', usi_si, 24*60*60);
			} catch(err) {
				usi_commons.report_error(err);
			}
			return usi_si;
		},
		get_id: function(usi_append) {
			if (!usi_append) usi_append = "";
			var usi_id = null;
			try {
				if (usi_cookies.get('usi_v') == null && usi_cookies.get('usi_id'+usi_append) == null) {
					var usi_rand_str = Math.random().toString(36).substring(2);
					if (usi_rand_str.length > 6) usi_rand_str = usi_rand_str.substring(0, 6);
					usi_id = usi_rand_str + "_" + Math.round((new Date()).getTime() / 1000);
					usi_cookies.set('usi_id'+usi_append, usi_id, 30 * 86400, true);
					return usi_id;
				}
				if (usi_cookies.get('usi_v') != null) usi_id = usi_cookies.get('usi_v');
				if (usi_cookies.get('usi_id'+usi_append) != null) usi_id = usi_cookies.get('usi_id'+usi_append);
				usi_cookies.set('usi_id'+usi_append, usi_id, 30 * 86400, true);
			} catch(err) {
				usi_commons.report_error(err);
			}
			return usi_id;
		},
		load_session_data: function(extended) {
			try {
				if (usi_cookies.get_json("usi_session_data") == null) {
					usi_commons.load_script(usi_commons.domain + '/utility/session_data.jsp?extended=' + (extended?"true":"false"));
				} else {
					usi_app.session_data = usi_cookies.get_json("usi_session_data");
					if (typeof(usi_app.session_data_callback) !== "undefined") {
						usi_app.session_data_callback();
					}
				}
			} catch(err) {
				usi_commons.report_error(err);
			}
		}
	};
	setTimeout(function() {
		try {
			if (usi_commons.gup_or_get_cookie("usi_debug") != "") usi_commons.debug = true;
			if (usi_commons.gup_or_get_cookie("usi_qa") != "") {
				usi_commons.domain = usi_commons.cdn = "https://prod.upsellit.com";
			}
		} catch(err) {
			usi_commons.report_error(err);
		}
	}, 1000);
}
if (typeof usi_ajax === 'undefined') {
	usi_ajax = {};
	usi_ajax.get = function (url, callback) {
		try {
			return usi_ajax.get_with_options({url: url}, callback);
		} catch (err) {
			usi_commons.report_error(err);
		}
	};
	usi_ajax.get_with_options = function (options, callback) {
		if (callback == null) {
			callback = function () {};
		}
		var result = {};
		options = (options || {});
		options.headers = (options.headers || []);
		if (XMLHttpRequest == null) {
			return callback(new Error('XMLHttpRequest not supported'), result);
		}
		if ((options.url || '') === '') {
			return callback(new Error('url cannot be blank'), result);
		}
		try {
			var http = new XMLHttpRequest();
			http.open('GET', options.url, true);
			http.setRequestHeader('Content-type', 'application/json');
			options.headers.forEach(function (header) {
				if ((header.name || '') !== '' && (header.value || '') !== '') {
					http.setRequestHeader(header.name, header.value);
				}
			});
			http.onreadystatechange = function () {
				if (http.readyState === 4) {
					result.status = http.status;
					result.responseText = (http.responseText || '');
					var httpErr = null;
					if (String(http.status).indexOf("2") !== 0) {
						httpErr = new Error('http.status: ' + http.status);
					}
					return callback(httpErr, result);
				}
			};
			http.send();
		} catch (err) {
			usi_commons.report_error(err);
			return callback(err, result);
		}
	};
	usi_ajax.post = function (url, params, callback) {
		try {
			return usi_ajax.post_with_options({
				url: url,
				params: params
			}, callback);
		} catch (err) {
			usi_commons.report_error(err);
		}
	};
	usi_ajax.post_with_options = function (options, callback) {
		if (callback == null) {
			callback = function () {
			};
		}
		var result = {};
		options = (options || {});
		options.headers = (options.headers || []);
		options.paramsDataType = (options.paramsDataType || 'string');
		options.params = (options.params || '');
		if (XMLHttpRequest == null) {
			return callback(new Error('XMLHttpRequest not supported'), result);
		}
		if ((options.url || '') === '') {
			return callback(new Error('url cannot be blank'), result);
		}
		try {
			var http = new XMLHttpRequest();
			http.open('POST', options.url, true);
			if (options.paramsDataType === 'formData') {
			} else if (options.paramsDataType === 'object') {
				http.setRequestHeader('Content-type', 'application/json; charset=utf-8');
				options.params = JSON.stringify(options.params);
			} else {
				http.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
			}
			options.headers.forEach(function (header) {
				if ((header.name || '') !== '' && (header.value || '') !== '') {
					http.setRequestHeader(header.name, header.value);
				}
			});
			http.onreadystatechange = function () {
				if (http.readyState === 4) {
					result.status = http.status;
					result.responseText = (http.responseText || '');
					result.responseURL = (http.responseURL || '');
					var httpErr = null;
					if (String(http.status).indexOf("2") !== 0) {
						httpErr = new Error('http.status: ' + http.status);
					}
					return callback(httpErr, result);
				}
			};
			http.send(options.params);
		} catch (err) {
			usi_commons.report_error(err);
			return callback(err, result);
		}
	};
	usi_ajax.form_post = function (url, paramsObj, method) {
		try {
			method = (method || 'post');
			var formElement = document.createElement('form');
			formElement.setAttribute('method', method);
			formElement.setAttribute('action', url);
			if (paramsObj != null && typeof paramsObj === 'object') {
				Object.keys(paramsObj).forEach(function (key) {
					var fieldElement = document.createElement('input');
					fieldElement.setAttribute('type', 'hidden');
					fieldElement.setAttribute('name', key);
					fieldElement.setAttribute('value', paramsObj[key]);
					formElement.appendChild(fieldElement);
				});
			}
			document.body.appendChild(formElement);
			formElement.submit();
		} catch (err) {
			usi_commons.report_error(err);
		}
	};
	usi_ajax.put_with_options = function (options, callback) {
		if (callback == null) {
			callback = function () {
			};
		}
		var result = {};
		options = (options || {});
		options.headers = (options.headers || []);
		if (XMLHttpRequest == null) {
			return callback(new Error('XMLHttpRequest not supported'), result);
		}
		if ((options.url || '') === '') {
			return callback(new Error('url cannot be blank'), result);
		}
		try {
			var http = new XMLHttpRequest();
			http.open('PUT', options.url, true);
			http.setRequestHeader('Content-type', 'application/json');
			options.headers.forEach(function (header) {
				if ((header.name || '') !== '' && (header.value || '') !== '') {
					http.setRequestHeader(header.name, header.value);
				}
			});
			http.onreadystatechange = function () {
				if (http.readyState === 4) {
					result.status = http.status;
					result.responseText = (http.responseText || '');
					var httpErr = null;
					if (String(http.status).indexOf("2") !== 0) {
						httpErr = new Error('http.status: ' + http.status);
					}
					return callback(httpErr, result);
				}
			};
			http.send();
		} catch (err) {
			usi_commons.report_error(err);
			return callback(err, result);
		}
	};
	usi_ajax.get_with_script = function (src, removeAfterLoad, callback) {
		try {
			var result = {};
			if (removeAfterLoad == null) {
				removeAfterLoad = true;
			}
			var scriptID = 'usi_' + ((new Date()).getTime());
			var headElement = document.getElementsByTagName('head')[0];
			if (top.location != location) {
				headElement = parent.document.getElementsByTagName('head')[0];
			}
			var scriptElement = document.createElement('script');
			scriptElement.id = scriptID;
			scriptElement.type = 'text/javascript';
			scriptElement.src = src;
			scriptElement.addEventListener('load', function () {
				if (removeAfterLoad === true) {
					headElement.removeChild(scriptElement);
				}
				if (callback != null) {
					return callback(null, result);
				}
			});
			headElement.appendChild(scriptElement);
		} catch (err) {
			usi_commons.report_error(err);
		}
	};
	usi_ajax.listener = function listener(isDebugMode) {
		if (isDebugMode == null) {
			isDebugMode = false;
		}
		if (XMLHttpRequest != null) {
			var listener = this;
			listener.ajax = new Object();
			listener.clear = function () {
				listener.ajax.requests = [];
				listener.ajax.registeredRequests = [];
				listener.ajax.scriptLoads = [];
				listener.ajax.registeredScriptLoads = [];
			};
			listener.clear();
			listener.register = function (method, url, callback) {
				try {
					method = (method || '*').toUpperCase();
					url = (url || '*');
					callback = (callback || function () {
					});
					var registeredRequest = {
						method: method,
						url: url,
						callback: callback
					};
					listener.ajax.registeredRequests.push(registeredRequest);
				} catch (err) {
					usi_commons.report_error(err);
				}
			};
			listener.registerScriptLoad = function (url, callback) {
				try {
					url = (url || '*');
					callback = (callback || function () {
					});
					var registeredScriptLoad = {
						url: url,
						callback: callback
					};
					listener.ajax.registeredScriptLoads.push(registeredScriptLoad);
				} catch (err) {
					usi_commons.report_error(err);
				}
			};
			listener.registerFormSubmit = function (formElement, callback) {
				try {
					if (formElement != null) {
						usi_dom.attach_event('submit', function (e) {
							if (isDebugMode === true) {
								usi_commons.log('USI AJAX: form submit');
							}
							if (e != null) {
								if (e.returnValue === true) {
									e.preventDefault();
									var result = {
										action: formElement.action,
										data: {},
										e: e
									};
									var ignoreTypes = [
										'submit'
									];
									Array.prototype.slice.call(formElement.elements).forEach(function (element) {
										try {
											if (ignoreTypes.indexOf(element.type) === -1) {
												if (element.type === 'checkbox') {
													if (element.checked === true) {
														result.data[element.name] = element.value;
													}
												} else {
													result.data[element.name] = element.value;
												}
											}
										} catch (err) {
											usi_commons.report_error(err);
										}
									});
									if (callback != null) {
										return callback(null, result);
									} else {
										e.returnValue = true;
									}
								}
							}
						}, formElement);
					}
				} catch (err) {
					usi_commons.report_error(err);
				}
			};
			listener.listen = function () {
				try {
					listener.ajax.originalOpen = XMLHttpRequest.prototype.open;
					listener.ajax.originalSend = XMLHttpRequest.prototype.send;
					XMLHttpRequest.prototype.open = function (method, url) {
						var openXHR = this;
						method = (method || '').toUpperCase();
						url = (url || '');
						url = usi_dom.get_absolute_url(url);
						if (isDebugMode === true) {
							usi_commons.log('USI AJAX: open[' + method + ']: ' + url);
						}
						var requestObj = {
							method: method,
							url: url,
							openDate: new Date()
						};
						listener.ajax.requests.push(requestObj);
						var registeredRequest = null;
						listener.ajax.registeredRequests.forEach(function (existingRegisteredRequest) {
							if (existingRegisteredRequest.method == method || existingRegisteredRequest.method == '*') {
								if (url.indexOf(existingRegisteredRequest.url) > -1 || existingRegisteredRequest.url == '*') {
									registeredRequest = existingRegisteredRequest;
								}
							}
						});
						if (registeredRequest != null) {
							if (isDebugMode === true) {
								usi_commons.log('USI AJAX: Registered URL[' + method + ']: ' + url);
							}
							openXHR.requestObj = requestObj;
							openXHR.requestObj.callback = registeredRequest.callback;
						}
						listener.ajax.originalOpen.apply(openXHR, arguments);
					};
					XMLHttpRequest.prototype.send = function (data) {
						var sendXHR = this;
						if (sendXHR.requestObj != null) {
							if (isDebugMode === true) {
								usi_commons.log('USI AJAX: Send Registered URL[' + sendXHR.requestObj.method + ']: ' + sendXHR.requestObj.url);
							}
							if ((data || '') != '') {
								sendXHR.requestObj.params = data;
							}
							if (sendXHR.addEventListener) {
								sendXHR.addEventListener('readystatechange', function () {
									listener.ajax.readyStateChanged(sendXHR);
								}, false);
							} else {
								listener.ajax.proxifyOnReadyStateChange(sendXHR);
							}
						}
						listener.ajax.originalSend.apply(sendXHR, arguments);
					};
					listener.ajax.readyStateChanged = function (sendXHR) {
						if (sendXHR.readyState === 4) {
							if (sendXHR.requestObj != null) {
								sendXHR.requestObj.completedDate = new Date();
								if (isDebugMode === true) {
									usi_commons.log('Completed: ' + sendXHR.requestObj.url);
								}
								if (sendXHR.requestObj.callback != null) {
									var result = {
										requestObj: sendXHR.requestObj,
										responseText: sendXHR.responseText
									};
									return sendXHR.requestObj.callback(null, result);
								}
							}
						}
					};
					listener.ajax.proxifyOnReadyStateChange = function (sendXHR) {
						var originalOnReadyStateChange = sendXHR.onreadystatechange;
						if (originalOnReadyStateChange != null) {
							sendXHR.onreadystatechange = function () {
								listener.ajax.readyStateChanged(sendXHR);
								originalOnReadyStateChange();
							};
						}
					};
					document.head.addEventListener('load', function (event) {
						if (event != null && event.target != null && (event.target.src || '') != '') {
							var url = event.target.src;
							url = usi_dom.get_absolute_url(url);
							var scriptLoadResult = {
								url: url,
								completedDate: new Date()
							};
							listener.ajax.scriptLoads.push(scriptLoadResult);
							var registeredScriptLoad = null;
							listener.ajax.registeredScriptLoads.forEach(function (existingRegisteredScriptLoad) {
								if (url.indexOf(existingRegisteredScriptLoad.url) > -1 || existingRegisteredScriptLoad.url == '*') {
									registeredScriptLoad = existingRegisteredScriptLoad;
								}
							});
							if (registeredScriptLoad != null) {
								if (registeredScriptLoad.callback != null) {
									return registeredScriptLoad.callback(null, scriptLoadResult);
								}
							}
						}
					}, true);
					usi_commons.log('USI AJAX: listening ...');
				} catch (err) {
					usi_commons.report_error(err);
					usi_commons.log('usi_ajax.listener ERROR: ' + err.message);
				}
			};
			listener.unregisterAll = function () {
				listener.ajax.registeredRequests = [];
				listener.ajax.registeredScriptLoads = [];
			};
		}
	};
}if("undefined"==typeof usi_cookies&&(usi_cookies={expire_time:{minute:60,hour:3600,two_hours:7200,four_hours:14400,day:86400,week:604800,two_weeks:1209600,month:2592e3,year:31536e3,never:31536e4},max_cookies_count:15,max_cookie_length:1e3,update_window_name:function(e,o,i){try{var n=-1;if(-1!=i){var t=new Date;t.setTime(t.getTime()+1e3*i),n=t.getTime()}var r=window.top||window,s=0;null!=o&&-1!=o.indexOf("=")&&(o=o.replace(new RegExp("=","g"),"USIEQLS")),null!=o&&-1!=o.indexOf(";")&&(o=o.replace(new RegExp(";","g"),"USIPRNS"));for(var a=r.name.split(";"),u="",c=0;c<a.length;c++){var l=a[c].split("=");3==l.length?(l[0]==e&&(l[1]=o,l[2]=n,s=1),null!=l[1]&&"null"!=l[1]&&(u+=l[0]+"="+l[1]+"="+l[2]+";")):""!=a[c]&&(u+=a[c]+";")}0==s&&(u+=e+"="+o+"="+n+";"),r.name=u}catch(e){}},flush_window_name:function(e){try{for(var o=window.top||window,i=o.name.split(";"),n="",t=0;t<i.length;t++){var r=i[t].split("=");3==r.length&&(0==r[0].indexOf(e)||(n+=i[t]+";"))}o.name=n}catch(e){}},get_from_window_name:function(e){try{for(var o,i=(window.top||window).name.split(";"),n=0;n<i.length;n++){var t=i[n].split("=");if(3==t.length){if(t[0]==e&&(-1!=(o=t[1]).indexOf("USIEQLS")&&(o=o.replace(new RegExp("USIEQLS","g"),"=")),-1!=o.indexOf("USIPRNS")&&(o=o.replace(new RegExp("USIPRNS","g"),";")),!("-1"!=t[2]&&usi_cookies.datediff(t[2])<0)))return[o,t[2]]}else if(2==t.length&&t[0]==e)return-1!=(o=t[1]).indexOf("USIEQLS")&&(o=o.replace(new RegExp("USIEQLS","g"),"=")),-1!=o.indexOf("USIPRNS")&&(o=o.replace(new RegExp("USIPRNS","g"),";")),[o,(new Date).getTime()+6048e5]}}catch(e){}return null},datediff:function(e){return e-(new Date).getTime()},count_cookies:function(e){return e=e||"usi_",usi_cookies.search_cookies(e).length},root_domain:function(){try{var e=document.domain.split("."),o=e[e.length-1];if("com"==o||"net"==o||"org"==o||"us"==o||"co"==o||"ca"==o)return e[e.length-2]+"."+e[e.length-1]}catch(e){}return document.domain},create_cookie:function(e,o,i){if(!1!==navigator.cookieEnabled){var n="";if(-1!=i){var t=new Date;t.setTime(t.getTime()+1e3*i),n="; expires="+t.toGMTString()}var r="samesite=none;";0==location.href.indexOf("https://")&&(r+="secure;");var s=usi_cookies.root_domain();"undefined"!=typeof usi_parent_domain&&-1!=document.domain.indexOf(usi_parent_domain)&&(s=usi_parent_domain),document.cookie=e+"="+encodeURIComponent(o)+n+"; path=/;domain="+s+"; "+r}},create_nonencoded_cookie:function(e,o,i){if(!1!==navigator.cookieEnabled){var n="";if(-1!=i){var t=new Date;t.setTime(t.getTime()+1e3*i),n="; expires="+t.toGMTString()}var r="samesite=none;";0==location.href.indexOf("https://")&&(r+="secure;");var s=usi_cookies.root_domain();"undefined"!=typeof usi_parent_domain&&-1!=document.domain.indexOf(usi_parent_domain)&&(s=usi_parent_domain),document.cookie=e+"="+o+n+"; path=/;domain="+s+"; "+r}},read_cookie:function(e){if(!1===navigator.cookieEnabled)return null;var o=e+"=",i=[];try{i=document.cookie.split(";")}catch(e){}for(var n=0;n<i.length;n++){for(var t=i[n];" "==t.charAt(0);)t=t.substring(1,t.length);if(0==t.indexOf(o))return decodeURIComponent(t.substring(o.length,t.length))}return null},del:function(e){usi_cookies.set(e,null,-100);try{null!=localStorage&&localStorage.removeItem(e),null!=sessionStorage&&sessionStorage.removeItem(e)}catch(e){}},get_ls:function(e){try{var o=localStorage.getItem(e);if(null!=o){if(0==o.indexOf("{")&&-1!=o.indexOf("usi_expires")){var i=JSON.parse(o);if((new Date).getTime()>i.usi_expires)return localStorage.removeItem(e),null;o=i.value}return decodeURIComponent(o)}}catch(e){}return null},get:function(e){var o=usi_cookies.read_cookie(e);if(null!=o)return o;try{if(null!=localStorage&&null!=(o=usi_cookies.get_ls(e)))return o;if(null!=sessionStorage&&null!=(o=sessionStorage.getItem(e)))return decodeURIComponent(o)}catch(e){}var i=usi_cookies.get_from_window_name(e);if(null!=i&&i.length>1)try{o=decodeURIComponent(i[0])}catch(e){return i[0]}return o},get_json:function(e){var o=null,i=usi_cookies.get(e);if(null==i)return null;try{o=JSON.parse(i)}catch(e){i=i.replace(/\\"/g,'"');try{o=JSON.parse(JSON.parse(i))}catch(e){try{o=JSON.parse(i)}catch(e){}}}return o},search_cookies:function(e){e=e||"";var o=[];return document.cookie.split(";").forEach((function(i){var n=i.split("=")[0].trim();""!==e&&0!==n.indexOf(e)||o.push(n)})),o},set:function(e,o,i,n){"undefined"!=typeof usi_nevercookie&&(n=!1),void 0===i&&(i=-1);try{o=o.replace(/(\r\n|\n|\r)/gm,"")}catch(e){}"undefined"==typeof usi_windownameless&&usi_cookies.update_window_name(e+"",o+"",i);try{if(i>0&&null!=localStorage){var t={value:o,usi_expires:(new Date).getTime()+1e3*i};localStorage.setItem(e,JSON.stringify(t))}else null!=sessionStorage&&sessionStorage.setItem(e,o)}catch(e){}if(n||null==o){if(null!=o){if(null==usi_cookies.read_cookie(e))if(!n)if(usi_cookies.search_cookies("usi_").length+1>usi_cookies.max_cookies_count)return void usi_cookies.report_error('Set cookie "'+e+'" failed. Max cookies count is '+usi_cookies.max_cookies_count);if(o.length>usi_cookies.max_cookie_length)return void usi_cookies.report_error('Cookie "'+e+'" truncated ('+o.length+"). Max single-cookie length is "+usi_cookies.max_cookie_length)}usi_cookies.create_cookie(e,o,i)}},set_json:function(e,o,i,n){var t=JSON.stringify(o).replace(/^"/,"").replace(/"$/,"");usi_cookies.set(e,t,i,n)},flush:function(e){e=e||"usi_";var o,i,n,t=document.cookie.split(";");for(o=0;o<t.length;o++)0==(i=t[o]).trim().toLowerCase().indexOf(e)&&(n=i.trim().split("=")[0],usi_cookies.del(n));usi_cookies.flush_window_name(e);try{if(null!=localStorage)for(var r in localStorage)0==r.indexOf("usi_")&&localStorage.removeItem(r);if(null!=sessionStorage)for(var r in sessionStorage)0==r.indexOf("usi_")&&sessionStorage.removeItem(r)}catch(e){}},print:function(){for(var e=document.cookie.split(";"),o="",i=0;i<e.length;i++){var n=e[i];0==n.trim().toLowerCase().indexOf("usi_")&&(console.log(decodeURIComponent(n.trim())+" (cookie)"),o+=","+n.trim().toLowerCase().split("=")[0]+",")}try{if(null!=localStorage)for(var t in localStorage)0==t.indexOf("usi_")&&"string"==typeof localStorage[t]&&-1==o.indexOf(","+t+",")&&(console.log(t+"="+usi_cookies.get_ls(t)+" (localStorage)"),o+=","+t+",");if(null!=sessionStorage)for(var t in sessionStorage)0==t.indexOf("usi_")&&"string"==typeof sessionStorage[t]&&-1==o.indexOf(","+t+",")&&(console.log(t+"="+sessionStorage[t]+" (sessionStorage)"),o+=","+t+",")}catch(e){}for(var r=(window.top||window).name.split(";"),s=0;s<r.length;s++){var a=r[s].split("=");if(3==a.length&&0==a[0].indexOf("usi_")&&-1==o.indexOf(","+a[0]+",")){var u=a[1];-1!=u.indexOf("USIEQLS")&&(u=u.replace(new RegExp("USIEQLS","g"),"=")),-1!=u.indexOf("USIPRNS")&&(u=u.replace(new RegExp("USIPRNS","g"),";")),console.log(a[0]+"="+u+" (window.name)"),o+=","+n.trim().toLowerCase().split("=")[0]+","}}},value_exists:function(){var e,o;for(e=0;e<arguments.length;e++)if(""===(o=usi_cookies.get(arguments[e]))||null===o||"null"===o||"undefined"===o)return!1;return!0},report_error:function(e){"undefined"!=typeof usi_commons&&"function"==typeof usi_commons.report_error&&usi_commons.report_error(e)}},"undefined"!=typeof usi_commons&&"function"==typeof usi_commons.gup&&"function"==typeof usi_commons.gup_or_get_cookie))try{""!=usi_commons.gup("usi_email_id")?usi_cookies.set("usi_email_id",usi_commons.gup("usi_email_id").split(".")[0],Number(usi_commons.gup("usi_email_id").split(".")[1]),!0):null==usi_cookies.read_cookie("usi_email_id")&&null!=usi_cookies.get_from_window_name("usi_email_id")&&(usi_commons.load_script("https://www.upsellit.com/launch/blank.jsp?usi_email_id_fix="+encodeURIComponent(usi_cookies.get_from_window_name("usi_email_id")[0])),usi_cookies.set("usi_email_id",usi_cookies.get_from_window_name("usi_email_id")[0],(usi_cookies.get_from_window_name("usi_email_id")[1]-(new Date).getTime())/1e3,!0)),""!=usi_commons.gup_or_get_cookie("usi_debug")&&(usi_commons.debug=!0),""!=usi_commons.gup_or_get_cookie("usi_qa")&&(usi_commons.domain=usi_commons.cdn="https://prod.upsellit.com")}catch(e){usi_commons.report_error(e)}
usi_parent_domain = "dnb.com"
usi_commons.load = function(usiHash, usiSiteID, usiKey, callback){
	usiKey = usiKey || "";
	var source = this.domain + "/usi_load.jsp?hash=" + usiHash + "&siteID=" + usiSiteID + "&keys=" + usiKey;
	this.load_script(source, callback);
};
if (typeof usi_app === 'undefined') {
	try {
		usi_app = {};
		usi_app.main = function () {
			// General
			usi_app.version = 'v1.2.0';
			usi_app.url = location.href.toLowerCase();
			usi_app.device = usi_commons.is_mobile ? 'mobile' : 'desktop';
			usi_app.coupon = usi_cookies.value_exists("usi_coupon_applied") ? "" : usi_commons.gup_or_get_cookie("usi_coupon", usi_cookies.expire_time.week, true);
			usi_app.checkout_url = 'https://cart.dnb.com/checkout';
			usi_app.root = 'https://creditbuilder.dnb.com/services';
			usi_app.report_date = null;
			usi_app.DUNS = usi_commons.gup_or_get_cookie('duns');
			usi_app.DUNS_QUERY = 'dunsNumber=' + usi_app.DUNS;
			// Indicates we're on their QA/STG site
			if (usi_app.url.indexOf("malibucoding") != -1) {
				usi_app.checkout_url = 'https://cart-stg.malibucoding.com/checkout';
				usi_app.root = 'https://creditbuilder-stg.malibucoding.com/services';
			}

			// Pages
			usi_app.is_home_page = location.pathname == "/";
			usi_app.is_cart = usi_app.url.indexOf(usi_app.checkout_url) != -1;
			usi_app.is_success = usi_app.url.indexOf("/success") != -1;
			usi_app.is_product_summary = usi_app.url.indexOf('/report/summary') != -1;
			usi_app.is_login = usi_app.url.indexOf('/login') != -1;
			usi_app.is_IE = usi_app.url.indexOf('country=ie') != -1;
			usi_app.is_GB = usi_app.url.indexOf('country=gb') != -1;
			usi_app.is_QA = usi_app.url.indexOf('qa.malibucoding') != -1;
			usi_app.is_STG = usi_app.url.indexOf('stg.malibucoding') != -1;
			usi_app.is_business_directory = usi_app.url.indexOf('/businessdirectory/') != -1;
			usi_app.report_url = usi_app.root + '/product/report?' + usi_app.DUNS_QUERY + '&countryCode=US';
			usi_app.is_duns_home_page = usi_app.url.indexOf('duns-update.dnb.com') != -1 || usi_app.url.indexOf('duns-update-stg.malibucoding.com') != -1;

			if (usi_commons.gup("irclickid") != "" && (location.href.indexOf("usi_email_id") != -1 || usi_cookies.get("usi_clicked_1") != null)) {
				usi_cookies.del("usi_clicked_1");
				var date_now = Date.now().toString();
				var cookie_value = date_now + "|-1|" + date_now + "|" + usi_commons.gup("irclickid") + "|";
				usi_cookies.create_nonencoded_cookie("IR_2075", cookie_value, 30 * 24 * 60 * 60, true);
				usi_cookies.create_nonencoded_cookie("irclickid", usi_commons.gup("irclickid"), 30 * 24 * 60 * 60, true);
			}

			// Flags
			usi_app.is_enabled = usi_commons.gup_or_get_cookie("usi_enable", usi_cookies.expire_time.day, true) != "";
			usi_app.rules_overridden = usi_commons.gup_or_get_cookie("usi_override_rules", usi_cookies.expire_time.day, true) != "";

			// Load pixel on confirmation page
			if (usi_app.is_success) {
				usi_commons.load_script("https://www.upsellit.com/active/dun_bradstreet_v2_pixel.jsp");
				return;
			}
			
			// Suppressions
			if (!(document.domain.indexOf("dnb.com") != -1 || location.href.indexOf("/businessdirectory/") != -1 || location.href.indexOf("qa.malibucoding.com") != -1 || location.href.indexOf("stg.malibucoding.com") != -1)) {
				return;
			}

			usi_app.register_launch_buttons();

			if (usi_app.is_enabled) {
				usi_commons.log_success('[ main ] Testing Enabled!');
			}

			// Cookie set in 21938 which redirects users to cart, so we load this after the redirect
			if (usi_cookies.get("usi_clicked") != null) {
				usi_cookies.del("usi_clicked");
				usi_app.link_injection("https://dandb.7eer.net/c/16669/84628/2075?url=https://www.dandb.com");
			}

			if (usi_cookies.get('usi_do_ajax') === '1' && usi_app.is_cart) {
				usi_cookies.del('usi_do_ajax');
				usi_app.add_product();
			}
			if (usi_app.creditbuilder.is_report_summary_page || usi_app.creditbuilder.is_report_insights_page || usi_app.creditbuilder.is_risk_assessments_page) {
				usi_app.creditbuilder.set_trade_reference_info();
			}

			// Apply coupon code
			if (document.querySelector('#promoC') != null && document.querySelector('#btn-apply-coupon') != null && usi_app.coupon != "") {
				setTimeout(function () {
					usi_app.apply_coupon();
				}, 3000);
				return;
			}

			// Suppressed in IE/GB countries
			if (usi_app.country === 'us') {
				usi_app.load();
			}
		};

		usi_app.create_cookie = function (name, value, exp_seconds) {
			var expires = "";
			if (exp_seconds != -1) {
				var date = new Date();
				date.setTime(date.getTime() + (exp_seconds * 1000));
				expires = "; expires=" + date.toGMTString();
			}
			document.cookie = name + "=" + value + expires + "; domain=.dnb.com; path=/;";
		};

		usi_app.load = function () {

			// Determine dashboard type
			usi_app.dashboard_type = '';
			if (usi_app.is_product_summary && typeof usi_app.entitlements != "undefined" && usi_app.entitlements.length > 0) {
				usi_commons.log('[ load ] entitlements:', usi_app.entitlements);

				// Determine type via logo class
				if (document.querySelector('.cb-logo')) {
					usi_app.dashboard_type = 'credit_signal';
				} else if (document.querySelector('.cs-plus-logo')) {
					usi_app.dashboard_type = 'credit_signal_plus';
				}

				// Double check for cs plus keyword in entitlements
				var blob = JSON.stringify(usi_app.entitlements).toLowerCase();
				if (blob.indexOf('creditsignal plus') !== -1) {
					usi_app.dashboard_type = 'credit_signal_plus';
				} else if (blob.indexOf('creditmonitor') !== -1) {
					usi_app.dashboard_type = 'credit_monitor';
				}
				
				// Creditsignal is Catalog ID 14625 (awaiting others)
				if(blob.indexOf('14625') != -1){
					usi_app.dashboard_type = 'credit_signal';
				}else if(blob.indexOf('3203') != -1){
					usi_app.dashboard_type = 'credit_monitor';
				}
				
				usi_app.is_us_business = typeof usi_app.entitlements[0].business != "undefined" && typeof usi_app.entitlements[0].business.country != "undefined" && usi_app.entitlements[0].business.country == "US";

				usi_commons.log('[ load ] dashboard_type:', usi_app.dashboard_type);
			}
			
			if (usi_app.dashboard_type === 'credit_signal' && usi_app.is_us_business) {
				// Credit Signal specific solutions (US only)
				if (!usi_cookies.value_exists('usi_launched')) {
					// Upgrade to Creditmonitor
					if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') {
						usi_js.cleanup();
					}
					if (!usi_cookies.value_exists('usi_suppress_banner')) {
						usi_app.banner.remove_old_banner();
						var interval = setInterval(function () {
							if (document.querySelector('upgrade-box > div.hide-in-pdf') != null) {
								if (typeof usi_30941 == "undefined") {
									usi_commons.load('0DhJCWUabVwAuAP3n8xI0hL','30941', usi_commons.device, function(){});
								}
								if (typeof usi_32623 == "undefined") {
									usi_commons.load('lKQp65qSjDyMAC4Vx1xhH9u','32623', usi_commons.device, function(){});
								}
								
								if(typeof usi_30941 != "undefined" && typeof usi_30941.load != "undefined" && typeof usi_32623 != "undefined" && typeof usi_32623.load != "undefined"){
									usi_30941.load();
									usi_32623.load();
									usi_app.banner.load();
									clearInterval(interval);
								}
							}
						}, 2000);
					}
					
					usi_commons.load_view("6MXgkGHcKU6yzwpZi0Ok3ra", "30431", usi_commons.device);
					setTimeout(function () {
						usi_app.creditmonitor.set_listeners();
					}, 1000);
				}
			} else if(usi_app.dashboard_type === 'credit_monitor' && usi_app.is_us_business && usi_app.is_enabled) {
				// Credit Monitor specific solutions (US only)
				if (!usi_cookies.value_exists('usi_launched')) {
					usi_commons.load_view("MlX5hT7jpBDOoui2kpDTF75", "32927", usi_commons.device);
					
					// Logout Button (Right Top Menu - Hover)
					if (document.querySelector('a.portal-view-logout') != null) {
						document.querySelector('a.portal-view-logout').removeEventListener('mouseover', function () {
							if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') {
								usi_js.cleanup();
							}
							
							usi_commons.load_view("MlX5hT7jpBDOoui2kpDTF75", "32927", usi_commons.device + "_logout");
						});
						document.querySelector('a.portal-view-logout').addEventListener('mouseover', function () {
							if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') {
								usi_js.cleanup();
							}
							
							usi_commons.load_view("MlX5hT7jpBDOoui2kpDTF75", "32927", usi_commons.device + "_logout");
						});
					}
				}
			} else if(usi_app.is_duns_home_page && !usi_cookies.value_exists('usi_click_id')){
				usi_commons.log('Loading DUNS In Page and Abandonment Banner');
				var interval2 = setInterval(function () {
					if(document.querySelector('div.view') != null && document.querySelector('div.duns-number-container') != null){
						if (typeof window['usi_38243'] == "undefined") {
							usi_commons.load("Ok8W2opxkbYVjwULzjArr1s", "38243", usi_commons.device, function(){
								window['usi_38243']['load']();
							});
						}
						if (typeof window['usi_38245'] == "undefined") {
							usi_commons.load("qUMW3FGvKwR4SLbGk0cbaH2", "38245", usi_commons.device, function(){
								window['usi_38245']['load']();
							});
						}
						usi_commons.load_view("iaRvQiHwuTZuCluZ6tVlY7I", "38257", usi_commons.device);
						usi_commons.log('DUNS In Page and Abandonment Banner loaded successfully');
						clearInterval(interval2);
					}
				}, 3000);
			}
			
			if (usi_app.is_cart && document.querySelector('#login-form-main-div') != null) {
				var products = document.querySelector('#login-form-main-div').innerHTML;
				usi_app.cart_has_credit_advisor = products.indexOf('Credit Advisor 1 Pack') > -1;
				usi_app.cart_has_business_info_report = products.indexOf('Business Information Report 1 Pack') > -1;
				usi_app.cart_has_business_background_report = products.indexOf('Business Background Report') > -1;
				usi_app.cart_has_creditbuilder = products.indexOf('CreditBuilder Plus') > -1;
				usi_app.cart_has_creditmonitor = products.indexOf('CreditMonitor') > -1;
				usi_app.cart_has_credibility_review = (products.indexOf('Credibility Review Silver') > -1 || products.indexOf('Credibility Review Gold') > -1 || products.indexOf('Credibility Review Platinum') > -1);
				usi_app.cart_has_credit_evaluator = products.indexOf('Credit Evaluator Plus 1 Pack') > -1;
				//New PCs
				usi_app.cart_has_creditsignal_plus = products.indexOf('CreditSignal Plus') > -1;
				usi_app.cart_has_creditbuilder_premium = products.indexOf('CreditBuilder Premium') > -1;
				usi_app.cart_has_BIR_snapshot = products.indexOf('BIR Snapshot 1 Pack') > -1;
				usi_app.cart_has_BIR_on_demand = products.indexOf('BIR On Demand 1 Pack') > -1;
				if(usi_app.cart_has_creditsignal_plus){
					usi_commons.log('[Email] Loading CreditSignal Plus');
					usi_commons.load_precapture("5rWiRtLQaa6T7uANutcDJn8", "34673");
				} else if(usi_app.cart_has_creditbuilder_premium){
					usi_commons.log('[Email] Loading CreditBuilder Premium');
					usi_commons.load_precapture("RxhhrSLfyP1rypV7qBDHDoe", "34689");
				} else if(usi_app.cart_has_BIR_snapshot){
					usi_commons.log('[Email] Loading BIR Snapshot');
					usi_commons.load_precapture("6WmylaBzRli1iq1YiziVqzZ", "34697");
				} else if(usi_app.cart_has_BIR_on_demand){
					usi_commons.log('[Email] Loading BIR On Demand');
					usi_commons.load_precapture("b7lsAayUVEaa2REtgoC5nbV", "34709");
				}else if (usi_app.cart_has_business_background_report) {
					usi_commons.log('[Email] Loading Business Background Report');
					usi_commons.load_precapture('8PmKjL3OYbqLC0TMyh2JQB0', '22864');
				} else if (usi_app.cart_has_business_info_report) {
					usi_commons.log('[Email] Loading Business Info Report');
					usi_commons.load_precapture('Nf8eB57uowcW5rLCmgXziOc', '22862');
				} else if (usi_app.cart_has_creditmonitor) {
					usi_commons.log('[Email] Loading Creditmonitor');
					usi_commons.load_precapture('di8kZiPthwZwxzOkjSvSEMl', '23162');
				} else if (usi_app.cart_has_credit_evaluator) {
					usi_commons.log('[Email] Loading Credit Evaluator');
					usi_commons.load_precapture('wf5hfTsHZ9wwLg9XnV4q0p6', '23166');
				} else if (usi_app.cart_has_creditbuilder) {
					usi_commons.log('[Email] Loading CreditBuilder');
					usi_commons.load_precapture('sj5r8EeVhl6BSITrgQ6Oio6', '23210');
				} else if (usi_app.cart_has_credit_advisor) {
					usi_commons.log('[Email] Loading Credit Advisor');
					usi_commons.load_precapture('74VKq3irt7e8UI2x8iC3Dhv', '23214');
				} else if (usi_app.cart_has_credibility_review) {
					usi_commons.log('[Email] Loading Credibility Review');
					usi_commons.load_precapture('tRKM9gttHmpVQ8FSvSsNSii', '23218');
				} else {
					usi_commons.log('[Email] Loading Catch All');
					usi_commons.load_precapture("Dh3fPSMIejRbPYvU5y6VerT", "11950");
				}
			} else if (usi_app.is_login) {
				usi_commons.load_precapture('8l2PhcQhthpu1rSdAtRaoML', '15716');
			}
		};
		usi_app.register_launch_buttons = function() {
			var text = 'Get a unique global identifier';
			var buttons = usi_dom.get_elements('.launch').filter(function(button) {
				return button.parentNode.parentNode.textContent.indexOf(text) > -1;
			});
			buttons.forEach(function(button) {
			    usi_dom.attach_event('click', function() {
			      usi_app.report_actions('COS Lead (Free DUNS)');
			    }, button);
			});
		};
		usi_app.report_actions = function(action) {
			usi_cookies.set('usi_why', action, usi_cookies.expire_time.day);
			var trigger = 'UNIQUE_TRIGGER_2';
			var triggerCookie = usi_cookies.get(trigger);
			var noUniqueTrigger = triggerCookie === null;
			var hasUniqueTrigger = triggerCookie === '1';
			var oneClickReport = '//www.upsellit.com/hound/monitor.jsp?qs=rRepgAAmfClcIpSlXSZoE7R&siteID=16566';
			var twoClickReport = '//www.upsellit.com/hound/monitor.jsp?qs=rRepgAAmfClcIpSlXSZoE7R&siteID=12078';
			if (noUniqueTrigger) {
				usi_commons.load_script(oneClickReport);
				usi_cookies.set(trigger, '1', usi_cookies.expire_time.day);
			} else if (hasUniqueTrigger) {
				usi_commons.load_script(twoClickReport);
				usi_cookies.set(trigger, '2', usi_cookies.expire_time.day);
			}
		};
		usi_app.add_creditbuilder_to_cart = function (){
			var data = {
				priceId: '13682',
				productId: '14284',
				source: 'creditbuilder',
				unique_id: '7615136010',
				_token: '123124u404rr48',
				dunsNumber: usi_app.DUNS,
				parentOrderItemId: '',
				api_key: 'ZjEwNWJkYmRlMjU2YjBiNGZkYzM0MDM1'
			};
			
			if (usi_app.is_STG) {
				data.priceId = '29585';
			}
			
			if (!usi_app.is_STG && !usi_app.is_QA) {
				data.priceId = '14751';
			}
			
			usi_app.get_parent_order_item_id(function(id) {
				data.parentOrderItemId = id;
				usi_ajax.form_post(usi_app.checkout_url, data, 'post');
			});
		};
		usi_app.add_creditbuilder_to_cart_from_admin = function (){
			var data = {
				priceId: '13045',
				productId: '9012',
				source: 'dandb',
				unique_id: '6546749046',
				_token: '6781944433',
				dunsNumber: usi_app.DUNS,
				duns: '063517483',
				productCategoryCode: 'SMO',
				productTypeCode: 'PKG',
				parentOrderItemId: usi_app.entitlements[0].product.sales_order_item_identifier,
				api_key: 'ODBmODNhMDdmNjI0YjQ3Y2U5YjhiZmVj'
			};
			
			if(usi_app.is_QA){
				usi_ajax.form_post("https://cart-qa.malibucoding.com/checkout", data, 'post');
			}else if(usi_app.is_STG){
				usi_ajax.form_post("https://cart-stg.malibucoding.com/checkout", data, 'post');
			}else{
				usi_ajax.form_post(usi_app.checkout_url, data, 'post');
			}
		};
		usi_app.add_creditbuilder_to_cart_from_banner = function (){
			var data = {
				priceId: '14890',
				productId: '14631',
				source: 'dandb',
				unique_id: '6546749046',
				_token: '6781944433',
				dunsNumber: usi_app.DUNS,
				duns: '063517483',
				productCategoryCode: 'SMO',
				productTypeCode: 'PKG',
				api_key: 'ODBmODNhMDdmNjI0YjQ3Y2U5YjhiZmVj'
			};
			
			if(usi_app.is_QA){
				data.priceId = '37243';
				usi_ajax.form_post("https://cart-qa.malibucoding.com/checkout", data, 'post');
			}else if(usi_app.is_STG){
				data.priceId = '29751';
				usi_ajax.form_post("https://cart-stg.malibucoding.com/checkout", data, 'post');
			}else{
				usi_ajax.form_post(usi_app.checkout_url + "?utm_source=creditsignal&utm_medium=in_product&utm_campaign=upsell_creditbuilder_plus&utm_content=cb_plus_banner", data, 'post');
			}
		};
		usi_app.add_creditmonitor_to_cart_from_banner = function (){
			//used in 32623
			var data = {
				priceId: '14895',
				productId: '14633',
				source: 'dandb',
				unique_id: '6546749046',
				_token: '6781944433',
				dunsNumber: usi_app.DUNS,
				productCategoryCode: 'SMO',
				productTypeCode: 'PKG',
				api_key: 'ODBmODNhMDdmNjI0YjQ3Y2U5YjhiZmVj'
			};
			
			if(usi_app.is_QA){
				data.priceId = '37271';
				usi_ajax.form_post("https://cart-qa.malibucoding.com/checkout", data, 'post');
			}else if(usi_app.is_STG){
				data.priceId = '29874';
				usi_ajax.form_post("https://cart-stg.malibucoding.com/checkout", data, 'post');
			}else{
				usi_ajax.form_post(usi_app.checkout_url + "?utm_source=creditsignal&utm_medium=in_product&utm_campaign=upsell_creditmonitor&utm_content=cm_banner", data, 'post');
			}
		};
		usi_app.add_creditmonitor_to_cart_from_admin = function (){
			//used in 30431
			var data = {
				priceId: '14895',
				productId: '14633',
				source: 'dandb',
				unique_id: '6546749046',
				_token: '6781944433',
				dunsNumber: usi_app.DUNS,
				productCategoryCode: 'SMO',
				productTypeCode: 'PKG',
				api_key: 'ODBmODNhMDdmNjI0YjQ3Y2U5YjhiZmVj'
			};
			
			if(usi_app.is_QA){
				data.priceId = '37271';
				usi_ajax.form_post("https://cart-qa.malibucoding.com/checkout", data, 'post');
			}else if(usi_app.is_STG){
				data.priceId = '29874';
				usi_ajax.form_post("https://cart-stg.malibucoding.com/checkout", data, 'post');
			}else{
				usi_ajax.form_post(usi_app.checkout_url + "?utm_source=creditsignal&utm_medium=in_product&utm_campaign=upsell_creditmonitor&utm_content=cm_exit_intent", data, 'post');
			}
		};
		usi_app.add_creditmonitor_to_cart_from_admin_proactive = function (){
			//used in 30427
			var data = {
				priceId: '14895',
				productId: '14633',
				source: 'dandb',
				unique_id: '6546749046',
				_token: '6781944433',
				dunsNumber: usi_app.DUNS,
				productCategoryCode: 'SMO',
				productTypeCode: 'PKG',
				api_key: 'ODBmODNhMDdmNjI0YjQ3Y2U5YjhiZmVj'
			};
			if(usi_app.is_QA){
				data.priceId = '37271';
				usi_ajax.form_post("https://cart-qa.malibucoding.com/checkout", data, 'post');
			}else if(usi_app.is_STG){
				data.priceId = '29874';
				usi_ajax.form_post("https://cart-stg.malibucoding.com/checkout", data, 'post');
			}else{
				usi_ajax.form_post(usi_js.campaign.link, data, 'post');
			}
		};
		usi_app.add_dm_to_cart_monthly = function (){
			//used in 38257, 38245, 38243
			usi_app.DUNS = document.querySelector('div.duns-number-container').textContent.replace(/[^0-9.]/g, '');
			var data = {
				priceId: '15028',
				productId: '14681',
				source: 'dandb',
				unique_id: '6546749046',
				_token: '6781944433',
				dunsNumber: usi_app.DUNS,
				productCategoryCode: 'SMO',
				productTypeCode: 'PKG',
				api_key: 'ODBmODNhMDdmNjI0YjQ3Y2U5YjhiZmVj'
			};
			
			if(typeof window['usi_js'] != "undefined" && typeof window['usi_js']['abandonment_click'] != "undefined"){
				usi_app.form_post(usi_app.checkout_url + "?utm_medium=in_product_DM&utm_campaign=upsell_blplus&utm_content=blplus_exit_intent", data, 'post');
			}else{
				usi_app.form_post(usi_app.checkout_url + "?utm_medium=in_product_DM&utm_campaign=upsell_blplus&utm_content=blplus_banner", data, 'post');
			}
		};
		usi_app.add_dm_to_cart_yearly = function (){
			//used in 38257, 38245, 38243
			usi_app.DUNS = document.querySelector('div.duns-number-container').textContent.replace(/[^0-9.]/g, '');
			var data = {
				priceId: '15029',
				productId: '14681',
				source: 'dandb',
				unique_id: '6546749046',
				_token: '6781944433',
				dunsNumber: usi_app.DUNS,
				productCategoryCode: 'SMO',
				productTypeCode: 'PKG',
				api_key: 'ODBmODNhMDdmNjI0YjQ3Y2U5YjhiZmVj'
			};
			
			if(typeof window['usi_js'] != "undefined" && typeof window['usi_js']['abandonment_click'] != "undefined"){
				usi_app.form_post(usi_app.checkout_url + "?utm_medium=in_product_DM&utm_campaign=upsell_blplus&utm_content=blplus_exit_intent", data, 'post');
			}else{
				usi_app.form_post(usi_app.checkout_url + "?utm_medium=in_product_DM&utm_campaign=upsell_blplus&utm_content=blplus_banner", data, 'post');
			}
		};
		usi_app.get_parent_order_item_id = function(callback) {
			var env = usi_app.is_STG ? 'stg' : 'dnb';
			var rootUrl = 'https://creditbuilder.' + env +'.com/services/users/me?dunsNumber=';
			
			usi_ajax.get(rootUrl + usi_app.DUNS, function(err, response) {
				if (!response || err) {
				    usi_commons.log('Error getting parent order item ID');
				    return;
				}
				
				var data = {};
				var parentOrderItemId = null;
				var creditBuilder = 'CreditBuilder Free Package';
				
				try {
				    data = JSON.parse(response.responseText);
				} catch(e) {
				    data = {};
				}
	
				data.entitlements.forEach(function(obj) {
					if (obj.product && obj.product.name.trim() === creditBuilder) {
						parentOrderItemId = obj.product.sales_order_item_identifier;
					}
				});
				
				if (typeof callback === 'function') {
					return callback(parentOrderItemId);
				}
			});
		};
		usi_app.month_diff = function (d1,d2){
			var months;
			months = (d2.getFullYear() - d1.getFullYear()) * 12;
			months -= d1.getMonth() + 1;
			months += d2.getMonth();
			return months <= 0 ? 0 : months;
		};
		usi_app.creditbuilder = {
			TRADE_REFERENCE_URL: 'https://' + location.host + '/services/product/count',
			PAYDEX_SCORE_URL: 'https://' + location.host + '/services/product/report',
			ACCOUNT_INFO_URL: 'https://' + location.host + '/services/users/me',
			is_report_summary_page: location.href.indexOf('/report/summary') != -1,
			is_report_insights_page: location.href.indexOf('/insights?duns=') != -1,
			is_risk_assessments_page: location.href.indexOf('/report/risk-assessment') != -1,
			is_staging_site: location.href.indexOf('creditbuilder-qa.malibucoding') != -1 || location.href.indexOf('dashboard-qa.malibucoding') != -1,
			get_severity: function (score){
				if(score < 21){
					return "High Risk";
				}else if(21 <= score && score < 40){
					return "Moderate High Risk";
				}else if(40 <= score && score < 60){
					return "Moderate Risk";
				}else if(60 <= score && score < 70){
					return "Low Moderate Risk";
				}else if(70 <= score){
					return "Low Risk";
				}
			},
			set_trade_reference_info: function (){
				var duns_number = usi_commons.gup_or_get_cookie('duns');
				var timestamp = "1683681463953";
				
				usi_commons.log('Fetching Trade Reference Info...');
				usi_ajax.get(usi_app.creditbuilder.TRADE_REFERENCE_URL + "?dunsNumber=" + duns_number + "&productType=TRD_REF&timeStamp=" + timestamp, function(err, response) {
					if (!response || err) {
						usi_commons.log_error('Failed To Fetch Trade Reference Info');
						return;
					}
					
					usi_commons.log('-----Trade Reference Info Fetched-----');
					
					var data = {};
					
					try {
						data = JSON.parse(response.responseText);
					} catch(e) {
						data = {};
					}
					
					usi_app.product_utilized_count = data.product_utilized_count;
					usi_app.product_available_count = data.product_available_count;
					
					usi_app.creditbuilder.is_onboarding_interval_eligible();
				});
			},
			is_onboarding_interval_eligible: function (){
				var duns_number = usi_commons.gup_or_get_cookie('duns');
				usi_commons.log('Fetching Account Info...');
				usi_ajax.get(usi_app.creditbuilder.ACCOUNT_INFO_URL + "?dunsNumber=" + duns_number, function(err, response) {
					if (!response || err) {
						usi_commons.log_error('Failed To Fetch Account Info');
						return false;
					}
					
					usi_commons.log('-----Account Info Fetched-----');
					
					var data = {};
					
					try {
						data = JSON.parse(response.responseText);
						usi_app.user_data = data;
					} catch(e) {
						data = {};
					}
					
					if(!data.show_intro){
						usi_commons.log_success('Has Seen Video: ' + !data.show_intro);
					}else{
						usi_commons.log_error('Has Seen Video: ' + !data.show_intro);
					}
					
					var catalog_eligible = false;
					
					for(var i = 0; i < data.entitlements.length; i++){
						if(typeof data.entitlements[i].product !== "undefined" && typeof data.entitlements[i].product.catalog_identifier !== "undefined"){
							if(data.entitlements[i].product.catalog_identifier === 3300){
								catalog_eligible = true;
							}
						}
					}
					
					usi_app.entitlements = data.entitlements;
					
					//Date eligible
					var date_eligible = false;
					try{
						var entitlement_date = new Date(Date.parse(usi_app.entitlements[0].product.entitlement_start_date));
						var current_date = new Date();
						var months = [2,4,6,8];
						
						for(var i = 0; i < months.length; i++) {
							if (usi_app.month_diff(entitlement_date, current_date) === months[i]) {
								date_eligible = true;
							}
						}
						
					}catch(e){}
					
					if(usi_app.rules_overridden){
						catalog_eligible = true;
						date_eligible = true;
					}
					
					//Catalog ID must be 3300
					if(data.entitlements[0].product.catalog_identifier == 3300){
						usi_commons.log_success('Catalog ID: ' + data.entitlements[0].product.catalog_identifier);
					}else{
						usi_commons.log_error('Catalog ID: ' + data.entitlements[0].product.catalog_identifier);
					}
					
					//Date must be 2, 4, 6, or 8 months after entitlement date
					if(date_eligible){
						usi_commons.log_success('Date Eligible: ' + date_eligible);
						
					}else{
						usi_commons.log_error('Date Eligible: ' + date_eligible);
					}
					
					
					usi_cookies.set('usi_onboarding_eligible', ((!data.show_intro && catalog_eligible && date_eligible)), usi_cookies.expire_time.week);
					usi_app.load();
				});
			},
			is_trade_reference_eligible: function (){
				
				//Must have at least 1 trade reference available
				if(usi_app.product_available_count === "Unlimited" || (usi_app.product_available_count > 0)){
					usi_commons.log_success('Trade References: ' + usi_app.product_available_count);
				}else{
					usi_commons.log_error('Trade References: ' + usi_app.product_available_count);
				}
				
				if(typeof usi_app.product_available_count === "undefined" || typeof usi_app.product_utilized_count === "undefined") return false;
				
				return (usi_app.product_available_count === "Unlimited" || (usi_app.product_available_count > 0));
			}
		};
		usi_app.creditsignal = {
			is_date_eligible: function (){
				try{
					var oneDay = 24 * 60 * 60 * 1000;
					var current_date = new Date();
					var entitlement_date = new Date(Date.parse(usi_app.entitlements[0].product.entitlement_start_date));
					var diffDays = Math.round(Math.abs((entitlement_date - current_date) / oneDay));
					return diffDays < 31;
				}catch(e){
					usi_commons.log('Credit Signal: Entitlement Date Not Found');
					return false;
				}
			},
			set_listeners: function (){
				//proactive TT
				if(document.querySelector('#left-hand-menu') != null){
					document.querySelector('aside.sidebar').addEventListener('click',usi_app.creditsignal.load_leftnav);
				}
				if(document.querySelectorAll('span.icon-arrow-right2')[1] != null){
					document.querySelectorAll('span.icon-arrow-right2')[1].addEventListener('click',usi_app.creditsignal.load_leftnav_inquiries_arrow);
				}
				if(document.querySelector('div.scores-and-ratings-panel') != null){
					document.querySelector('div.scores-and-ratings-panel').addEventListener('click',usi_app.creditsignal.load_score);
				}
				if(document.querySelector('div.summary-company-profile') != null){
					document.querySelector('div.summary-company-profile').addEventListener('click',usi_app.creditsignal.load_company);
				}
				if(document.querySelector('div.risk-assessment-panel') != null){
					document.querySelector('div.risk-assessment-panel').addEventListener('click',usi_app.creditsignal.load_risk);
				}
				if(document.querySelector('li.insights-button') != null){
					document.querySelector('li.insights-button').addEventListener('click',usi_app.creditsignal.load_insights);
				}
				//abandonment TT
				if(document.querySelector('a.portal-view-logout') != null){
					document.querySelector('a.portal-view-logout').addEventListener('mouseover',usi_app.creditsignal.load_logout);
				}
			},
			load_leftnav: function (e){
				if(typeof usi_app.selected_tab_nav !== "undefined") return;
				usi_commons.log('Loading CS Modal');
				try{
					var tabs = ['Risk Assessment','Legal Events','Special Events','Ownership','Company Profile','Financials','Inquiries','Peers','Trade References', 'Trade Payments', 'DUNS Manager', 'Return to Dashboard','Update Company'];
					tabs = tabs.filter(function(t){
						return (e.target.innerHTML.indexOf(t) != -1)
					});
				}catch(e){}

				usi_app.selected_tab_nav = "Navigation";
				if(typeof tabs != "undefined" && tabs.length === 1){
					usi_app.selected_tab_nav = tabs[0];
				}

				if(usi_app.selected_tab_nav == 'DUNS Manager' || usi_app.selected_tab_nav == 'Return to Dashboard' || usi_app.selected_tab_nav == 'Update Company') return;
				if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') {
					usi_js.cleanup();
				}
				usi_commons.load_view("KBxwov3d36GMY3Q3sUb3H4H", "29693", usi_commons.device + "_left");
			},
			load_leftnav_inquiries_arrow: function (){
				usi_commons.log('Loading CS Modal');
				usi_app.selected_tab_nav = "Inquiries";
				if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') {
					usi_js.cleanup();
				}
				usi_commons.load_view("KBxwov3d36GMY3Q3sUb3H4H", "29693", usi_commons.device + "_left");
			},
			load_score: function (){
				usi_commons.log('Loading CS Modal');
				if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') {
					usi_js.cleanup();
				}
				usi_commons.load_view("KBxwov3d36GMY3Q3sUb3H4H", "29693", usi_commons.device + "_score");
			},
			load_company: function (){
				usi_commons.log('Loading CS Modal');
				if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') {
					usi_js.cleanup();
				}
				usi_commons.load_view("KBxwov3d36GMY3Q3sUb3H4H", "29693", usi_commons.device + "_company");
			},
			load_risk: function (){
				usi_commons.log('Loading CS Modal');
				if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') {
					usi_js.cleanup();
				}
				usi_commons.load_view("KBxwov3d36GMY3Q3sUb3H4H", "29693", usi_commons.device + "_risk");
			},
			load_insights: function (){
				usi_commons.log('Loading CS Modal');
				if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') {
					usi_js.cleanup();
				}
				usi_commons.load_view("KBxwov3d36GMY3Q3sUb3H4H", "29693", usi_commons.device + "_insights");
			},
			load_logout: function (){
				usi_commons.log('Loading CS Modal');
				if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') {
					usi_js.cleanup();
				}
				usi_commons.load_view("wwXl7ZrwGsqpGZYAy3IAji8", "30043", usi_commons.device + "_logout");
			}
		};
		usi_app.creditmonitor = {
			set_listeners: function () {
				usi_commons.log('[ creditmonitor ] Setting event listeners...');

				// -------------------------------------------------------------------------
				// --------------------------- Left Nav Elements ---------------------------
				// -------------------------------------------------------------------------
				var left_sidebar_general_tabs = ['summary', 'risk-assessment', 'trade-payments', 'legal-events', 'special-events', 'ownership', 'company-profile', 'financials', 'inquiries', 'peers', 'trade-references'];
				left_sidebar_general_tabs.forEach(function (tab_name) {
					if (document.querySelector('span[translate="' + tab_name + '"]') != null) {
						var parent = document.querySelector('span[translate="' + tab_name + '"]').parentElement;
						if (parent) {
							usi_commons.log('[ creditmonitor.set_listeners ] left_nav:', tab_name);
							parent.removeEventListener('click', usi_app.creditmonitor.load_leftnav);
							parent.addEventListener('click', usi_app.creditmonitor.load_leftnav);
						}
					}
				});

				// -------------------------------------------------------------------------
				// ----------------------------- Body Elements -----------------------------
				// -------------------------------------------------------------------------

				// Scores and Ratings Block (Body)
				var scores_and_ratings_el = document.querySelector('div.scores-and-ratings-panel');
				if (scores_and_ratings_el) {
					usi_commons.log('[ creditmonitor.set_listeners ] body: Scores and Ratings');
					scores_and_ratings_el.removeEventListener('click', function () {
						usi_app.creditmonitor.load_score();
					});
					scores_and_ratings_el.addEventListener('click', function () {
						usi_app.creditmonitor.load_score();
					});
				}

				// Company Profile Block (Body)
				var company_profile_el = document.querySelector('div.summary-company-profile');
				if (company_profile_el) {
					usi_commons.log('[ creditmonitor.set_listeners ] body: Company Profile');
					company_profile_el.removeEventListener('click', function () {
						usi_app.creditmonitor.load_company();
					});
					company_profile_el.addEventListener('click', function () {
						usi_app.creditmonitor.load_company();
					});
				}

				// -------------------------------------------------------------------------
				// ---------------------------- Header Elements ----------------------------
				// -------------------------------------------------------------------------

				// INSIGHTS Button (Top Bar)
				if (document.querySelector('li.insights-button') != null) {
					usi_commons.log('[ creditmonitor.set_listeners ] header: Insights');
					document.querySelector('li.insights-button').removeEventListener('click', function () {
						usi_app.creditmonitor.load_insights();
					});
					document.querySelector('li.insights-button').addEventListener('click', function () {
						usi_app.creditmonitor.load_insights();
					});
				}

				// Logout Button (Right Top Menu - Hover)
				if (document.querySelector('a.portal-view-logout') != null) {
					usi_commons.log('[ creditmonitor.set_listeners ] header: Logout (hover)');
					document.querySelector('a.portal-view-logout').removeEventListener('mouseover', function () {
						usi_app.creditmonitor.load_logout();
					});
					document.querySelector('a.portal-view-logout').addEventListener('mouseover', function () {
						usi_app.creditmonitor.load_logout();
					});
				}
			},
			load_leftnav: function (e) {
				if (e && e.target && e.target.getAttribute('translate')) {

					// Get tab name
					var tab_name = e.target.getAttribute('translate');
					usi_commons.log('[ creditmonitor.load_leftnav ] tab_name:', tab_name);

					// Clean up previous solutions
					if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') usi_js.cleanup();

					// Load corresponding configs
					if (tab_name === 'risk-assessment') {
						usi_commons.load_view("2JiWfuWoEPVQISeuDoAwqj4", "30427", usi_commons.device + "_risk");
					} else if (tab_name === 'peers') {
						usi_commons.load_view("2JiWfuWoEPVQISeuDoAwqj4", "30427", usi_commons.device + "_peers");
					} else if (tab_name === 'trade-references') {
						usi_commons.load_view("2JiWfuWoEPVQISeuDoAwqj4", "30427", usi_commons.device + "_trade");
					} else {
						usi_commons.load_view("2JiWfuWoEPVQISeuDoAwqj4", "30427", usi_commons.device + "_left");
					}
				}
			},
			load_score: function () {
				if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') usi_js.cleanup();
				usi_commons.load_view("2JiWfuWoEPVQISeuDoAwqj4", "30427", usi_commons.device + "_score");
			},
			load_company: function () {
				if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') usi_js.cleanup();
				usi_commons.load_view("2JiWfuWoEPVQISeuDoAwqj4", "30427", usi_commons.device + "_company");
			},
			load_insights: function () {
				if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') usi_js.cleanup();
				usi_commons.load_view("2JiWfuWoEPVQISeuDoAwqj4", "30427", usi_commons.device + "_insights");
			},
			load_logout: function () {
				if (typeof usi_js !== 'undefined' && typeof usi_js.cleanup === 'function') usi_js.cleanup();
				usi_commons.load_view("6MXgkGHcKU6yzwpZi0Ok3ra", "30431", usi_commons.device + "_logout");
			},
			post_close: function () {
				// Increment clicks count
				if (usi_cookies.value_exists('usi_campaign_clicks')) {
					var clicks = Number(usi_cookies.get('usi_campaign_clicks'));
					usi_cookies.set('usi_campaign_clicks', (clicks + 1), usi_cookies.expire_time.week);
				} else {
					usi_cookies.set('usi_campaign_clicks', 1, usi_cookies.expire_time.week);
				}
				// Reload Abandonment TT
				setTimeout(function () {
					usi_commons.load_view("6MXgkGHcKU6yzwpZi0Ok3ra", "30431", usi_commons.device);
					usi_app.creditmonitor.set_listeners();
				}, 500)
			}
		};
		usi_app.banner = {
			load: function(){
				if(usi_cookies.value_exists('usi_suppress_banner')){
					return;
				}
				
				var usi_boost_css = ['.upgrade-box .information-container {display: flex; flex-direction: row !important; align-items: baseline; color: #fff;}',
					'.upgrade-box .information-container .information-content {margin: 0% !important; background: none; }',
					'div.report-headline-panel {margin-bottom: 0px !important;}',
					'.upgrade-box {padding-bottom: 24px;}'
				].join('');
				usi_app.banner.place_css(usi_boost_css);
				
				//remove existing box
				try{
					document.querySelector('upgrade-box > div.upgrade-box').remove();
				}catch(e){}
				
				//create our own
				var usi_container = document.createElement("div");
				usi_container.setAttribute("id","usi_container");
				usi_container.classList.add('upgrade-box');
				usi_container.classList.add('container-fluid');
				var usi_html = [
					'<div class="information-container">',
					'<div class="information-content">',
					'<div class="usi_sr_only" style="display: none">Monitor in real time to gain valuable insights into your business credit. Get Alerts when changes occur and have 24 7 access to the information in your Dun & Bradstreet business credit file. Call us at 1-844-840-8170 to discuss which product is right for you</div>',
					'<img src="'+usi_commons.cdn+'/chatskins/2641/DandB-TT-2-2021-inpage-creditmnitor.png" style="max-width: 650px; min-width: 350px; height: auto; cursor: pointer; width: 100%;" onclick="usi_app.banner.link_clicked(\'', 'MONITOR','\');"  aria-label="$39/mo Add to cart"/>',
					'</div>',
					'<div class="information-content">',
					'<div class="usi_sr_only" style="display: none">Monitor & take action to help build your business credit file. Potentially build your D&B credit file by submitting Trade References, subject to verification and acceptance, * to Dun & Bradstreet and get alerts when changes are made to your file. Call us at 1-844-840-8170 to discuss which product is right for you</div>',
					'<img src="'+usi_commons.cdn+'/chatskins/2641/DandB-TT-2-2021-inpage-creditbuilder.png" style="max-width: 650px; min-width: 350px; height: auto; cursor: pointer; width: 100%;" onclick="usi_app.banner.link_clicked(\'', 'BUILDER','\');"  aria-label="$149/mo Add to cart"/>',
					'</div>',
					'</div>'
				].join('');
				usi_container.innerHTML = usi_html;
				document.querySelector('upgrade-box').appendChild(usi_container);
			},
			remove_old_banner: function (){
				var styles = 'upgrade-box > div.hide-in-pdf { display: none; }';
				var styleSheet = document.createElement("style");
				styleSheet.type = "text/css";
				styleSheet.innerText = styles;
				document.head.appendChild(styleSheet);
			},
			link_clicked: function(product){
				usi_cookies.set('usi_suppress_banner', '1', usi_cookies.expire_time.week);
				if(product == "MONITOR"){
					usi_32623.link_clicked();
				}else{
					usi_30941.link_clicked();
				}
			},
			callback: function (product){
				if(product == "MONITOR"){
					usi_app.add_creditmonitor_to_cart_from_banner();
				}else{
					usi_app.add_creditbuilder_to_cart_from_banner();
				}
			},
			place_css:function(css) {
				var usi_css = document.createElement("style");
				usi_css.type = "text/css";
				if (usi_css.styleSheet) usi_css.styleSheet.cssText = css;
				else usi_css.innerHTML = css;
				document.getElementsByTagName('head')[0].appendChild(usi_css);
			}
		};
		usi_app.apply_coupon = function() {
			var coupon_input = document.querySelector('#promoC');
			var coupon_button = document.querySelector('#btn-apply-coupon');
			if (coupon_input !== null && coupon_button !== null) {
				coupon_input.value = usi_app.coupon;
				usi_cookies.set("usi_coupon_applied", usi_app.coupon, usi_cookies.expire_time.week);
				usi_cookies.del("usi_coupon");
				usi_app.coupon = "";
				coupon_button.disabled = false;
				coupon_button.click();
				setTimeout(usi_app.post_apply_coupon, 2000);
				usi_commons.log("Coupon applied");
			} else {
				if (usi_app.coupon_attempts == undefined) {
					usi_app.coupon_attempts = 0;
				} else if (usi_app.coupon_attempts >= 5) {
					usi_commons.report_error("Coupon elements not found");
					return;
				}
				usi_app.coupon_attempts++;
				usi_commons.log("Coupon elements missing, trying again. Tries: " + usi_app.coupon_attempts);
				setTimeout(usi_app.apply_coupon, 1000);
			}
		};
		usi_app.post_apply_coupon = function () {
			var error_element = document.querySelector("#ERROR_MESSAGE_ELEMENT");
			var error_message_exists = error_element != null && error_element.textContent.trim() != "";
			if (error_message_exists) {
				usi_commons.report_error("Coupon error message seen");
			} else {
				usi_commons.log_success("Coupon application was successful");
			}
		};
		// Append an iframe into the DOM with the given destination
		usi_app.link_injection = function(destination) {
			var usi_dynamic_div = document.createElement("div");
			usi_dynamic_div.innerHTML = "<iframe style='width:1px;height:1px' src='"+destination+"'></iframe>";
			document.getElementsByTagName('body')[0].appendChild(usi_dynamic_div);
		};
		usi_app.form_post = function (url, paramsObj, method) {
			try {
				method = (method || 'post');
				var formElement = document.createElement('form');
				formElement.setAttribute('method', method);
				formElement.setAttribute('action', url);
				formElement.setAttribute('target', "_blank");
				if (paramsObj != null && typeof paramsObj === 'object') {
					Object.keys(paramsObj).forEach(function (key) {
						var fieldElement = document.createElement('input');
						fieldElement.setAttribute('type', 'hidden');
						fieldElement.setAttribute('name', key);
						fieldElement.setAttribute('value', paramsObj[key]);
						formElement.appendChild(fieldElement);
					});
				}
				document.body.appendChild(formElement);
				formElement.submit();
			} catch (err) {
				usi_commons.report_error(err);
			}
		};

		usi_app.session_data_callback = function() {
			usi_app.country = usi_app.session_data.country;
			usi_app.main();
		};

		usi_dom.ready(function(){
			try {
				usi_commons.load_session_data();
			} catch (err) {
				usi_commons.report_error(err);
			}
		});
	} catch (err) {
		usi_commons.report_error(err);
	}
}