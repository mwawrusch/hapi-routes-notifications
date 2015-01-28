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
  Hoek.assert options.tenantId,i18n.optionsTenantIdRequired
  
  storeNotifications = -> plugin.plugins['hapi-store-notifications']
  Hoek.assert storeNotifications(),i18n.couldNotFindHapiStoreNotificationsPlugin

  hapiUserStoreMultiTenant = -> plugin.plugins['hapi-user-store-multi-tenant']
  users = ->
    hapiUserStoreMultiTenant().methods.users

    
  fnRaise404 = (request,reply) ->
    reply Boom.notFound("#{i18n.notFoundPrefix} #{options.baseUrl}#{request.path}")

  fnIsInServerAdmin = (request) ->
    scopes = (request.auth?.credentials?.scopes) || []
    return _.contains scopes,options.serverAdminScopeName


  ###
  Posting a notification to a single user or users who belong to a role.
  ###
  plugin.route
    path: "/notifications"
    method: "POST"
    config:
      description: i18n.descriptionNotificationsPost
      tags: options.tags
      validate:
        payload: Joi.object().keys(
            message: Joi.string()
            sendToRole: Joi.string() 
            sendToUserId: Joi.string()            
            actionLinkUrl: Joi.string().optional()
          ).without('sendToRole', 'sendToUserId')
    handler: (request, reply) ->
      return reply Boom.unauthorized(i18n.authorizationRequired) unless request.auth?.credentials
      isInServerAdmin = fnIsInServerAdmin(request)
      

      fnCreateSingleMessage = (targetUserId,cb) ->
        data = 
          actionLinkUrl: request.payload.actionLinkUrl
          fromUserId: helperUserIdFromRequest(request)
          hasBeenRead: false
          involvesRole: request.payload.sendToRole
          message : request.payload.message
          messageType: 'message'
          owningUserId: targetUserId

        storeNotifications().methods.notifications.create data, {}, cb

      if request.payload.sendToUserId
        fnCreateSingleMessage request.payload.sendToUserId, (err,notification) ->
          return reply err if err
          baseUrl = options.baseUrl
          reply(helperObjToRest.notification(notification,baseUrl,isInServerAdmin)).code(201)
      else
        optionsQuery =
          where: 
            roles : request.payload.sendToRole

        console.log "Users with role #{request.payload.sendToRole}"
        users().all options.tenantId,optionsQuery, (err,userResults) ->
          console.log "Error: #{err}" if err
          return reply err if err
          console.log "USERS: #{JSON.stringify(userResults.items)}"

          userIds = _.pluck userResults.items, '_id'
          console.log "PLUCKED IDS: #{JSON.stringify(userIds)}"

          async.eachSeries userIds,fnCreateSingleMessage, (err) ->
            console.log "RETURNED ERROR #{err}" if err
            return reply err if err

            reply({}).code(201)
