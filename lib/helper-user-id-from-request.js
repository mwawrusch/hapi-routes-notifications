
/*
Returns the user id from a request
 */

(function() {
  module.exports = function(request) {
    var _ref, _ref1, _ref2;
    return (_ref = request.auth) != null ? (_ref1 = _ref.credentials) != null ? (_ref2 = _ref1.id) != null ? _ref2.toString() : void 0 : void 0 : void 0;
  };

}).call(this);

//# sourceMappingURL=helper-user-id-from-request.js.map
