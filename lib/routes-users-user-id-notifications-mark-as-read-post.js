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
    var hapiUserStoreMultiTenant, storeNotifications, users;
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

    /*    
    fnRaise404 = (request,reply) ->
      reply Boom.notFound("#{i18n.notFoundPrefix} #{options.baseUrl}#{request.path}")
    
    fnIsInServerAdmin = (request) ->
      scopes = (request.auth?.credentials?.scopes) || []
      return _.contains scopes,options.serverAdminScopeName
     */
    return plugin.route({
      path: "/users/{userId}/notifications/mark-as-read",
      method: "POST",
      config: {
        description: i18n.descriptionNotificationsMarkAsRead,
        tags: options.tags,
        validate: {
          params: Joi.object().keys({
            userId: validationSchemas.validateId.required()
          }),
          payload: Joi.object().options({
            allowUnknown: true,
            stripUnknown: true
          })
        }
      },
      handler: function(request, reply) {
        var queryOptions;
        queryOptions = {
          where: {
            hasBeenRead: false,
            owningUserId: new ObjectId(request.params.userId.toString())
          }
        };
        return storeNotifications().methods.notifications.all(queryOptions, function(err, notificationsResult) {
          var fnMarkAsRead;
          if (err) {
            return reply(err);
          }
          fnMarkAsRead = function(notification, cb) {
            return storeNotifications().methods.notifications.patch(notification._id, {
              hasBeenRead: true
            }, null, cb);
          };
          return async.eachSeries(notificationsResult.items, fnMarkAsRead, function(err) {
            if (err) {
              return reply(err);
            }
            return reply({});
          });
        });
      }
    });
  };

}).call(this);

//# sourceMappingURL=routes-users-user-id-notifications-mark-as-read-post.js.map
