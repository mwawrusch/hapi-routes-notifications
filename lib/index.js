
/*
@author Martin Wawrusch (martin@wawrusch.com)
 */

(function() {
  var Hoek, i18n, routesToExpose, _;

  _ = require('underscore');

  Hoek = require('hoek');

  i18n = require('./i18n');

  routesToExpose = [require('./routes-notifications')];


  /*
  Main entry point for the plugin
  
  @param [Server] server the HAPI plugin
  @param [Object] options the plugin options
  @option options [String|Array] defaultFeatures a string or array of strings indicating the default features for each newly created notification.
  @option options [Number] maxOwnedNotificationsPerUser The maximum number of notifications a user can create (defaults to 1)
  @param [Function] cb the callback invoked after completion
  
  Please note that the routesBaseName is only included to make the life easier while doing the config of your HAPI server.
   */

  module.exports.register = function(server, options, cb) {
    var defaults, r, _i, _len;
    if (options == null) {
      options = {};
    }
    defaults = {
      maxOwnedNotificationsPerUser: 1
    };
    options = Hoek.applyToDefaults(defaults, options);
    for (_i = 0, _len = routesToExpose.length; _i < _len; _i++) {
      r = routesToExpose[_i];
      r(server, options);
    }
    server.expose('i18n', i18n);
    return cb();
  };


  /*
  @nodoc
   */

  module.exports.register.attributes = {
    pkg: require('../package.json')
  };

}).call(this);

//# sourceMappingURL=index.js.map
