mongoose = require 'mongoose'
ObjectId = mongoose.Types.ObjectId

module.exports = 
  none: null
  anonymous:
    id: new ObjectId "13a88c31413019245de27da7"
    username: '13a88c31413019245de27da7'
    scope: ['user-anonymous-access']

  anonymous2:
    id: new ObjectId "13a88c31413019245de27da0"
    username: '13a88c31413019245de27da7'
    scope: ['user-anonymous-access']

  bearerWithNoAdminRoles:
    id: new ObjectId "13a88c31413019245de27da7"
    username: 'Martin Wawrusch'
    accountId: '13a88c31413019245de27da0'
    scope: ['user-bearer-access']
    roles: []

  bearerWithAdminRoles:
    id: new ObjectId "13a88c31413019245de27da7"
    username: 'Martin Wawrusch'
    accountId: '13a88c31413019245de27da0'
    scope: ['user-bearer-access']
    roles: ['admin']
