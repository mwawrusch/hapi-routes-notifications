_ = require 'underscore'

module.exports = 
  notification: (x) ->
    x = JSON.parse(JSON.stringify(x))
    delete x.__v
    x
