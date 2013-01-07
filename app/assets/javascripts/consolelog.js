// For those browsers that do not support console.log (yep, IE8 or earlier)
// define console.log as an empty function so that modern-ish javascript
// libs that expect console.log do not break. Code snippet coppied from
// http://blog.patspam.com/2009/the-curse-of-consolelog
if (!("console" in window) || !("firebug" in console)) {
  var names = ["log", "debug", "info", "warn", "error", "assert", "dir", "dirxml", "group", "groupEnd", "time", "timeEnd", "count", "trace", "profile", "profileEnd"];
  window.console = {};
  for (var i = 0, len = names.length; i < len; ++i) {
    window.console[names[i]] = function(){};
  }
}