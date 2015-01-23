_ = require 'underscore'
should = require 'should'

credentials = require './support/credentials'
fixtures = require './support/fixtures'
loadData = require './support/load-data'
loadServer = require './support/load-server'
shouldHttp = require './support/should-http'

describe 'with data in db', ->
  server = null
  data = null

  describe 'with server setup', ->

    beforeEach (cb) ->
      loadServer (err,serverResult,pluginResult) ->
        return cb err if err
        server = serverResult
        loadData pluginResult,(err,dataResult) ->
          return cb err if err
          data = dataResult
          cb err

    describe 'GET /users/[userId]/notifications', ->
      describe 'with SERVER ADMIN credentials', ->
        it 'should return a 200', (cb) ->
          shouldHttp.get server,"/users/#{credentials.anonymous.id}/notifications",credentials.anonymous,200, cb

    