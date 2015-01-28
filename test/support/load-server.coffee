_ = require 'underscore'
databaseCleaner = require './database-cleaner'
Hapi = require "hapi"
hapiUserStoreMultiTenant = require 'hapi-user-store-multi-tenant'
hapiStoreNotifications = require 'hapi-store-notifications'
index = require '../../lib/index'
mongoose = require 'mongoose'

fixtures = require './fixtures'

testMongoDbUrl = 'mongodb://localhost/codedoctor-test'
testPort = 5675
testHost = "localhost"
loggingEnabled = false


module.exports = loadServer = (cb) ->
  server = new Hapi.Server()
  server.connection
            port: testPort
            host: testHost

  pluginConf = [
      register: hapiUserStoreMultiTenant
    ,
      register: hapiStoreNotifications
    ,
      register: index
      options:
        baseUrl: '/'
        tenantId: "53af466e96ab7635384b71f1"
  ]

  mongoose.disconnect()
  mongoose.connect testMongoDbUrl, (err) ->
    return cb err if err
    databaseCleaner loggingEnabled, (err) ->
      return cb err if err

      server.register pluginConf, (err) ->

        plugin = server.plugins['hapi-store-notifications']
        plugin.rebuildIndexes (err) ->
          cb err,server,plugin


