(function() {
  var Joi, i18n, validateId;

  Joi = require("joi");

  i18n = require("./i18n");

  validateId = Joi.string().length(24);

  module.exports = {
    validateId: validateId,
    userId: validateId
  };

}).call(this);

//# sourceMappingURL=validation-schemas.js.map
