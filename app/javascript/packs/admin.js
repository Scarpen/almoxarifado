var jQuery = require("jquery");

// import jQuery from "jquery";
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;

require('@rails/ujs').start()
require("bootstrap");
require("admin-lte");
require('datatables.net-bs4')
