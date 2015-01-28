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
    Hoek.assert(options.tenantId, i18n.optionsTenantIdRequired);
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

    /*
    Posting a notification to a single user or users who belong to a role.
     */
    return plugin.route({
      path: "/notifications",
      method: "POST",
      config: {
        description: i18n.descriptionNotificationsPost,
        tags: options.tags,
        validate: {
          payload: Joi.object().keys({
            message: Joi.string(),
            sendToRole: Joi.string(),
            sendToUserId: Joi.string(),
            actionLinkUrl: Joi.string().optional()
          }).without('sendToRole', 'sendToUserId')
        }
      },
      handler: function(request, reply) {
        var fnCreateSingleMessage, isInServerAdmin, optionsQuery, _ref;
        if (!((_ref = request.auth) != null ? _ref.credentials : void 0)) {
          return reply(Boom.unauthorized(i18n.authorizationRequired));
        }
        isInServerAdmin = fnIsInServerAdmin(request);
        fnCreateSingleMessage = function(targetUserId, cb) {
          var data;
          data = {
            actionLinkUrl: request.payload.actionLinkUrl,
            fromUserId: helperUserIdFromRequest(request),
            hasBeenRead: false,
            involvesRole: request.payload.sendToRole,
            message: request.payload.message,
            messageType: 'message',
            owningUserId: targetUserId
          };
          return storeNotifications().methods.notifications.create(data, {}, cb);
        };
        if (request.payload.sendToUserId) {
          return fnCreateSingleMessage(request.payload.sendToUserId, function(err, notification) {
            var baseUrl;
            if (err) {
              return reply(err);
            }
            baseUrl = options.baseUrl;
            return reply(helperObjToRest.notification(notification, baseUrl, isInServerAdmin)).code(201);
          });
        } else {
          optionsQuery = {
            where: {
              roles: request.payload.sendToRole
            }
          };
          console.log("Users with role " + request.payload.sendToRole);
          return users().all(options.tenantId, optionsQuery, function(err, userResults) {
            var userIds;
            if (err) {
              console.log("Error: " + err);
            }
            if (err) {
              return reply(err);
            }
            console.log("USERS: " + (JSON.stringify(userResults.items)));
            userIds = _.pluck(userResults.items, '_id');
            console.log("PLUCKED IDS: " + (JSON.stringify(userIds)));
            return async.eachSeries(userIds, fnCreateSingleMessage, function(err) {
              if (err) {
                console.log("RETURNED ERROR " + err);
              }
              if (err) {
                return reply(err);
              }
              return reply({}).code(201);
            });
          });
        }
      }
    });
  };

}).call(this);

//# sourceMappingURL=routes-notifications-post.js.map
