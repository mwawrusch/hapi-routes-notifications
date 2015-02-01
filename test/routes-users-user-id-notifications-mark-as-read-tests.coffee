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

    describe 'POST /users/[userId]/notifications', ->
      describe 'with SERVER ADMIN credentials', ->
        it 'should return a 200', (cb) ->
          shouldHttp.post server,"/users/13a88c31413019245de27da0/notifications/mark-as-read",{} ,credentials.anonymous,200, (err) ->
            return cb err if err

            shouldHttp.get server,"/users/13a88c31413019245de27da0/notifications",credentials.anonymous,200, (err,response) ->
              return cb err if err

              console.log JSON.stringify(response.result)

              should.exist response.result.items
              response.result.items.should.be.instanceof(Array).and.have.lengthOf(0)

    
              cb null


    