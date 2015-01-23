(function() {
  var _;

  _ = require('underscore');

  module.exports = {
    notification: function(x) {
      x = JSON.parse(JSON.stringify(x));
      delete x.__v;
      return x;
    }
  };

}).call(this);

//# sourceMappingURL=helper-obj-to-rest.js.map
