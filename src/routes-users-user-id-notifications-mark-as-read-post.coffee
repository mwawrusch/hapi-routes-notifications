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
  Hoek.assert options.baseUrl,i18n.optionsBaseUrlRequired

  storeNotifications = -> plugin.plugins['hapi-store-notifications']
  Hoek.assert storeNotifications(),i18n.couldNotFindHapiStoreNotificationsPlugin

  hapiUserStoreMultiTenant = -> plugin.plugins['hapi-user-store-multi-tenant']
  users = ->
    hapiUserStoreMultiTenant().methods.users

  ###    
  fnRaise404 = (request,reply) ->
    reply Boom.notFound("#{i18n.notFoundPrefix} #{options.baseUrl}#{request.path}")

  fnIsInServerAdmin = (request) ->
    scopes = (request.auth?.credentials?.scopes) || []
    return _.contains scopes,options.serverAdminScopeName
  ###

  plugin.route
    path: "/users/{userId}/notifications/mark-as-read"
    method: "POST"
    config:
      description: i18n.descriptionNotificationsMarkAsRead
      tags: options.tags
      validate:
        params: Joi.object().keys(
          userId: validationSchemas.validateId.required()
          )
        payload: Joi.object().options({allowUnknown: true, stripUnknown:true})


    handler: (request, reply) ->
      # Security:
      # requires user in either admin role, or be the current user
      # also should allow me
      # optionally check for write scope as well.

      queryOptions = 
        where:
          userId: new ObjectId(request.params.userId.toString()) #ObjectIdhelper here

      storeNotifications().methods.notifications.all  queryOptions,  (err,notificationsResult) ->
        return reply err if err

        fnMarkAsRead = (notification, cb) ->
          storeNotifications().methods.notifications.patch notification._id, hasBeenRead : true, null, cb

        async.eachSeries notificationsResult.items,fnMarkAsRead, (err) ->
          return reply err if err

          reply {}
