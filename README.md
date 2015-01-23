[![Build Status](https://travis-ci.org/codedoctor/hapi-routes-notifications.svg?branch=master)](https://travis-ci.org/codedoctor/hapi-routes-notifications)
[![Coverage Status](https://img.shields.io/coveralls/codedoctor/hapi-routes-notifications.svg)](https://coveralls.io/r/codedoctor/hapi-routes-notifications)
[![NPM Version](http://img.shields.io/npm/v/hapi-routes-notifications.svg)](https://www.npmjs.org/package//hapi-routes-notifications)
[![Dependency Status](https://gemnasium.com/codedoctor/hapi-routes-notifications.svg)](https://gemnasium.com/codedoctor/hapi-routes-notifications)
[![NPM Downloads](http://img.shields.io/npm/dm/hapi-routes-notifications.svg)](https://www.npmjs.org/package/hapi-routes-notifications)
[![Issues](http://img.shields.io/github/issues/codedoctor/hapi-routes-notifications.svg)](https://github.com/codedoctor/hapi-routes-notifications/issues)
[![HAPI 8.0](http://img.shields.io/badge/hapi-8.0-blue.svg)](http://hapijs.com)
[![API Documentation](http://img.shields.io/badge/API-Documentation-ff69b4.svg)](http://coffeedoc.info/github/codedoctor/hapi-routes-notifications)

(C) 2014 Martin Wawrusch

Provides HAPI based notification management endpoints.

## POST /users/me/notifications

Creates a new notification. The notification is owned by the user who posts this (taken from the id field from the credentials.) The default options limit to one per user, but this can be overridden.




## more later
get /users/me/notifications/active --> Retrieves the currently active notification for the user
post /users/me/notification/active
get /users/me/notifications

get /notifications/:notificationId
patch /notifications/:notificationId
delete /notifications/:notificationId

post /notifications/:notificationId/credit-cards/stripe-card-token
get /notifications/:notificationId/credit-cards
delete /notifications/:notificationId/credit-cards/:creditCardId
get /notifications/:notificationId/default-credit-card

Later
post /notifications/:notificationId/users/invite






## Dependencies

* HAPI >= 6.5.0

## Plugins that must be loaded into your hapi server:

* hapi-store-notifications

## See also

* [hapi-auth-bearer-mw](https://github.com/codedoctor/hapi-auth-bearer-mw)
* [hapi-loggly](https://github.com/codedoctor/hapi-loggly)
* [hapi-mandrill](https://github.com/codedoctor/hapi-mandrill)
* [hapi-mongoose-db-connector](https://github.com/codedoctor/hapi-mongoose-db-connector)
* [hapi-oauth-store-multi-tenant](https://github.com/codedoctor/hapi-oauth-store-multi-tenant)
* [hapi-routes-authorization-and-session-management](https://github.com/codedoctor/hapi-routes-authorization-and-session-management)
* [hapi-routes-oauth-management](https://github.com/codedoctor/hapi-routes-oauth-management)
* [hapi-routes-notifications](https://github.com/codedoctor/hapi-routes-notifications)
* [hapi-routes-status](https://github.com/codedoctor/hapi-routes-status)
* [hapi-routes-users-authorizations](https://github.com/codedoctor/hapi-routes-users-authorizations)
* [hapi-routes-users](https://github.com/codedoctor/hapi-routes-users)
* [hapi-user-store-multi-tenant](https://github.com/codedoctor/hapi-user-store-multi-tenant)

and additionally

* [api-pagination](https://github.com/codedoctor/api-pagination)
* [mongoose-oauth-store-multi-tenant](https://github.com/codedoctor/mongoose-oauth-store-multi-tenant)
* [mongoose-rest-helper](https://github.com/codedoctor/mongoose-rest-helper)
* [mongoose-user-store-multi-tenant](https://github.com/codedoctor/mongoose-user-store-multi-tenant)

## Contributing
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the package.json, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2014 Martin Wawrusch 


