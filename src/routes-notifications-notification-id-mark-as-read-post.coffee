_ = require 'underscore'
apiPagination = require 'api-pagination'
Boom = require 'boom'
Hoek = require "hoek"
Joi = require 'joi'
async = require 'async'

helperObjToRest = require './helper-obj-to-rest'
i18n = require './i18n'
validationSchemas = require './validation-schemas'
helperUserIdFromRequest = require './helper-user-id-from-request'
mongoose = require 'mongoose'
ObjectId = mongoose.Types.ObjectId

###
Primary entry point for the plugin
###
module.exports = (plugin,options = {}) ->

  storeNotifications = -> plugin.plugins['hapi-store-notifications']
  Hoek.assert storeNotifications(),i18n.couldNotFindHapiStoreNotificationsPlugin


  plugin.route
    path: "/notifications/{notificationId}/mark-as-read"
    method: "POST"
    config:
      description: i18n.descriptionNotificationsMarkAsRead
      tags: options.tags
    handler: (request, reply) ->
      ###
      validation, roles,..
      ###
      storeNotifications().methods.notifications.patch request.params.notificationId, hasBeenRead : true, null, (err) ->
        return reply err if err
        reply {}
