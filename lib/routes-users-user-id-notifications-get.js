(function() {
  var Boom, Hoek, Joi, ObjectId, apiPagination, async, helperObjToRest, helperUserIdFromRequest, i18n, mongoose, validationSchemas, _;

  _ = require('underscore');

  apiPagination = require('api-pagination');

  Boom = require('boom');

  Hoek = require("hoek");

  Joi = require('joi');

  async = require('async');

  helperObjToRest = require('./helper-obj-to-rest');

  i18n = require('./i18n');

  validationSchemas = require('./validation-schemas');

  helperUserIdFromRequest = require('./helper-user-id-from-request');

  mongoose = require('mongoose');

  ObjectId = mongoose.Types.ObjectId;


  /*
  Primary entry point for the plugin
   */

  module.exports = function(plugin, options) {
    var fnIsInServerAdmin, fnRaise404, hapiUserStoreMultiTenant, storeNotifications, users;
    if (options == null) {
      options = {};
    }
    Hoek.assert(options.baseUrl, i18n.optionsBaseUrlRequired);
    storeNotifications = function() {
      return plugin.plugins['hapi-store-notifications'];
    };
    Hoek.assert(storeNotifications(), i18n.couldNotFindHapiStoreNotificationsPlugin);
    hapiUserStoreMultiTenant = function() {
      return plugin.plugins['hapi-user-store-multi-tenant'];
    };
    users = function() {
      return hapiUserStoreMultiTenant().methods.users;
    };
    fnRaise404 = function(request, reply) {
      return reply(Boom.notFound("" + i18n.notFoundPrefix + " " + options.baseUrl + request.path));
    };
    fnIsInServerAdmin = function(request) {
      var scopes, _ref, _ref1;
      scopes = ((_ref = request.auth) != null ? (_ref1 = _ref.credentials) != null ? _ref1.scopes : void 0 : void 0) || [];
      return _.contains(scopes, options.serverAdminScopeName);
    };
    return plugin.route({
      path: "/users/{userId}/notifications",
      method: "GET",
      config: {
        description: i18n.descriptionUsersNotificationsGet,
        tags: options.tags,
        validate: {
          params: validationSchemas.paramsUsersNotificationsGet
        }
      },
      handler: function(request, reply) {
        var queryOptions;
        queryOptions = {
          where: {
            owningUserId: new ObjectId(request.params.userId.toString()),
            hasBeenRead: false
          },
          sort: '-createdAt'
        };
        return storeNotifications().methods.notifications.all(queryOptions, function(err, notificationsResult) {
          if (err) {
            return reply(err);
          }
          notificationsResult.items = _.map(notificationsResult.items || [], function(x) {
            return helperObjToRest.notification(x);
          });
          console.log("POST TRANSFORM " + (JSON.stringify(notificationsResult)));
          return reply(apiPagination.toRest(notificationsResult, "/profiles"));
        });
      }
    });
  };

}).call(this);

//# sourceMappingURL=routes-users-user-id-notifications-get.js.map
