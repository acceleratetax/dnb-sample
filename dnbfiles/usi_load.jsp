
if (typeof usi_load === 'undefined') {
	usi_load = {
		Campaign: function (options) {
			this.id = options.id;
			this.cdn = usi_commons.cdn;
			this.company_id = options.company_id;
			this.site_id = options.site_id;
			this.email_id = options.email_id;
			this.config_id = options.config_id;
			this.cookie_append = options.cookie_append;
			this.launch_cookie = options.launch_cookie;
			this.click_cookie = options.click_cookie;
			this.sale_window = options.sale_window;
			this.affiliate_link = options.affiliate_link;
			this.affiliate_deep_link = options.affiliate_deep_link;
			this.error_reported = 0;
			this.css = options.css;
			this.do_not_encode_deeplink = options.do_not_encode_deeplink;
			this.original_site_id = options.original_site_id;
			this.link = function (url, new_window) {
				try {
					if (!url) url = this.affiliate_link;
					if (!url) return;
					usi_cookies.set("usi_clicked_1", "1", 60);
					usi_cookies.set('usi_click_id', this.id, this.sale_window, true);
					if (this.click_cookie && this.click_cookie > 0) this.set_launch_cookie(this.click_cookie);
					var destination = usi_commons.domain + '/link.jsp?id=' + this.id + '&cid=' + this.company_id + '&sid=' + this.site_id + '&duration=' + this.sale_window + '&url=' + encodeURIComponent(url);
					if (new_window) window.open(destination);
					else location.href = destination;
				} catch(err) {
					if (typeof usi_commons !== "undefined") usi_commons.report_error(err);
				}
			};
			this.deep_link = function (url, new_window) {
				try {
					if (!url) url = location.href;
					if (this.do_not_encode_deeplink != 1) {
						url = encodeURIComponent(url);
					}
					this.link(this.affiliate_deep_link + url, new_window);
				} catch(err) {
					if (typeof usi_commons !== "undefined") usi_commons.report_error(err);
				}
			};
			this.link_clicked = function() {
				try{
					usi_cookies.set('usi_click_id', this.id, this.sale_window, true);
					usi_cookies.set("usi_clicked_1", "1", 60);
					if (this.click_cookie && this.click_cookie > 0) this.set_launch_cookie(this.click_cookie);
					usi_commons.load_script(usi_commons.domain + '/link.jsp?id=' + this.id + '&cid=' + this.company_id + '&sid=' + this.site_id + '&duration=' + this.sale_window + "&ajax=2");
				} catch(err) {
					if (typeof usi_commons !== "undefined") usi_commons.report_error(err);
				}
			};
			this.link_injection = function(url, callback) {
				try {
					this.link_clicked();
					var iframe = document.createElement("iframe");
					iframe.style.width = "1px";
					iframe.style.height = "1px";
					if (url) {
						iframe.src = url;
					} else if (this.affiliate_link != "") {
						iframe.src = this.affiliate_link;
					} else if (this.affiliate_deep_link != "") {
						iframe.src = this.affiliate_deep_link + encodeURIComponent(location.href);
					}
					if (typeof callback == "function") iframe.onload = callback;
					document.getElementsByTagName('body')[0].appendChild(iframe);
				} catch(err) {
					if (typeof usi_commons !== "undefined") usi_commons.report_error(err);
				}
			};
			this.place_css = function(css) {
				try {
					var usi_css = document.createElement("style");
					usi_css.type = "text/css";
					if(usi_css.styleSheet) usi_css.styleSheet.cssText = css;
					else usi_css.innerHTML = css;
					usi_css.className = "usi_load_style";
					document.getElementsByTagName('head')[0].appendChild(usi_css);
				} catch(err) {
					if (typeof usi_commons !== "undefined") usi_commons.report_error(err);
				}
			};
			this.load = function () {
				try {
					if (usi_cookies.get("usi_loaded"+this.cookie_append) == null) {
						if (typeof(this.loaded) === "undefined" || this.loaded == false) {
							this.loaded = true;
							this.place_css(this.css);
							if (!options.extra_javascript.apply(this)) {
								return false;
							}
							if (this.launch_cookie && this.launch_cookie > 0) this.set_launch_cookie(this.launch_cookie);
							usi_commons.load_script(usi_commons.domain + '/load.jsp?id=' + this.id + '&url=' + encodeURIComponent(location.href));
						}
					}
				} catch(err) {
					if (typeof usi_commons !== "undefined") usi_commons.report_error(err);
				}
			};
			this.current_time = function() {
				try {
					var d = new Date();
					return d.getTime();
				} catch(err) {
					if (typeof usi_commons !== "undefined") usi_commons.report_error(err);
				}
			};
			this.set_launch_cookie = function(time){
				try {
					usi_cookies.set("usi_loaded"+this.cookie_append, "t"+this.current_time(), time, true);
				} catch(err) {
					if (typeof usi_commons !== "undefined") usi_commons.report_error(err);
				}
			};
			this.get_session = function () {
				try {
					var sess = "";
					if (usi_cookies.get("usi_sess") != null) {
						sess = usi_cookies.get("usi_sess");
					} else {
						sess = "usi_sess_" + this.site_id + "_" + Math.round(1000 * Math.random()) + "_" + (new Date()).getTime();
						usi_cookies.set("usi_sess", sess, 30 * 24 * 60 * 60, true);
					}
					return sess;
				} catch(err) {
					if (typeof usi_commons !== "undefined") usi_commons.report_error(err);
				}
			};
			this.send_data = function (name, value) {
				try {
					usi_commons.load_script(usi_commons.domain + "/hound/saveData.jsp?siteID=" + this.email_id +
						"&onsite_configID=" + this.config_id +
						"&USI_value=" + encodeURIComponent(value) + "&USI_name=" + encodeURIComponent(name) +
						"&USI_Session=" + this.get_session() + "&id=" + this.id + "&bustCache=" + (new Date()).getTime());
				} catch(err) {
					if (typeof usi_commons !== "undefined") usi_commons.report_error(err);
				}
			};
			this.error_report = function(err) {
				try {
					if (err == null) return;
					if (typeof err === 'string') err = new Error(err);
					if (!(err instanceof Error)) return;
					if (typeof(usi_commons.error_reported) !== "undefined") {
						return;
					}
					if(this.error_reported == 0) {
						this.error_reported = 1;
						if (location.href.indexOf('usishowerrors') !== -1) throw err;
						else usi_commons.load_script(usi_commons.domain + '/err.jsp?oops=' + encodeURIComponent(err.message) + '-' + encodeURIComponent(err.stack) + "&url=" + encodeURIComponent(location.href));
					}
				} catch(err) {
					if (typeof usi_commons !== "undefined") usi_commons.report_error(err);
				}
			};
			this.validate_email = function (email) {
				try {
					var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
					return re.test(email);
				} catch(err) {
					if (typeof usi_commons !== "undefined") usi_commons.report_error(err);
				}
			};
		}
	};
}
usi_30941 = new usi_load.Campaign({
	id: '6212085205616848478260',
	company_id: '2641',
	site_id: '30941',
	email_id: '0',
	config_id: '55235',
	sale_window: '3888000',
	cookie_append: '30941',
	launch_cookie: 0,
	click_cookie: 0,
	affiliate_link: '',
	affiliate_deep_link: '',
	do_not_encode_deeplink: '0',
	css: ".usi_display * {\tfont-size: 1em;\tline-height: 1;\tbox-sizing: border-box;}/* Submit Button */.usi_submitbutton:hover, .usi_submitbutton:active, .usi_submitbutton:focus {\tbackground: none;\tborder: none;}.usi_submitbutton {\tposition: absolute;\ttop: 70%;\tleft: 45%;\twidth: 45%;\theight: 15%;\tdisplay: inline-block;\toutline: none;\tbackground: none;\tborder: none;\tmargin: 0;\tpadding: 0;\tcursor: pointer;}.upgrade-box .information-container {    display: flex;    flex-direction: row !important;    align-items: center;}.upgrade-box .information-container .information-content {   margin: 2% !important;}",
	launch_methods: '3,',
	original_site_id: '30941',
	extra_javascript: function(){
		/** Extra Javascript: START */
		try {
			this.link_clicked = function() {
        usi_cookies.set('usi_click_id', this.id, this.sale_window, true);
        if (this.click_cookie && this.click_cookie > 0) this.set_launch_cookie(this.click_cookie);
        var destination = usi_commons.domain + '/link.jsp?id=' + this.id + '&cid=' + this.company_id + '&sid=' + this.site_id + '&duration=' + this.sale_window;
        usi_commons.load_script(destination + "&ajax=1", usi_app.add_creditbuilder_to_cart_from_banner());
      };
		} catch(err) {
			if (typeof usi_commons !== "undefined") usi_commons.report_error(err);
			return false;
		}
		return true;
		/** Extra Javascript: END */
	}
});

setTimeout(function(){
	usi_30941.load()
}.bind(this), 0);
