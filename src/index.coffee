###
@author Martin Wawrusch (martin@wawrusch.com)
###

_ = require 'underscore'
Hoek = require 'hoek'
i18n = require './i18n'

routesToExpose = [
    require './routes-notifications-notification-id-mark-as-read-post'
    require './routes-notifications-post'
    require './routes-users-user-id-notifications-get'
    require './routes-users-user-id-notifications-mark-as-read-post'
]

###
Main entry point for the plugin

@param [Server] server the HAPI plugin
@param [Object] options the plugin options
@option options [String|Array] defaultFeatures a string or array of strings indicating the default features for each newly created notification.
@option options [Number] maxOwnedNotificationsPerUser The maximum number of notifications a user can create (defaults to 1)
@param [Function] cb the callback invoked after completion

Please note that the routesBaseName is only included to make the life easier while doing the config of your HAPI server.
###
module.exports.register = (server, options = {}, cb) ->

  defaults =
    maxOwnedNotificationsPerUser: 1
    
  options = Hoek.applyToDefaults defaults, options

  r server,options for r in routesToExpose

  server.expose 'i18n',i18n

  cb()

###
@nodoc
###
module.exports.register.attributes =
  pkg: require '../package.json'

