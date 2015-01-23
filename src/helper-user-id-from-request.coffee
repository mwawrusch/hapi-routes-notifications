
###
Returns the user id from a request
###
module.exports = (request) ->
  request.auth?.credentials?.id?.toString()
