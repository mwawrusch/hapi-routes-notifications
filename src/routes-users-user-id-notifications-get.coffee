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

    
  fnRaise404 = (request,reply) ->
    reply Boom.notFound("#{i18n.notFoundPrefix} #{options.baseUrl}#{request.path}")

  fnIsInServerAdmin = (request) ->
    scopes = (request.auth?.credentials?.scopes) || []
    return _.contains scopes,options.serverAdminScopeName



  plugin.route
    path: "/users/{userId}/notifications"
    method: "GET"
    config:
      description: i18n.descriptionUsersNotificationsGet
      tags: options.tags
      validate:
        params: validationSchemas.paramsUsersNotificationsGet

    handler: (request, reply) ->
      queryOptions = 
        where:
          owningUserId: new ObjectId request.params.userId.toString()
          hasBeenRead: false
        sort: '-createdAt'

      #console.log "QUERY: #{JSON.stringify(queryOptions)}"

      storeNotifications().methods.notifications.all  queryOptions,  (err,notificationsResult) ->
        #console.log "NOTIFICAITON RESULT: #{JSON.stringify(notificationsResult)}"
        #console.log "NOT ERROR: #{err}" if err
        return reply err if err

        notificationsResult.items = _.map(notificationsResult.items || [], (x) -> helperObjToRest.notification(x) ) 
        console.log "POST TRANSFORM #{JSON.stringify(notificationsResult)}"

        reply( apiPagination.toRest( notificationsResult,"/profiles"))
