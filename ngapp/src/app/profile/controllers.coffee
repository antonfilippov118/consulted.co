app = angular.module "consulted.profile.controllers", [
  "consulted.users.services"
]


app.controller "SettingsController", [
  '$scope'
  'User'
  '$timeout'
  (scope, User, $timeout) ->
    scope.loading = yes
    User.getProfile().then (user) ->
      scope.user = user
    , (err) ->
      scope.error = yes
    .finally () ->
      scope.loading = no

    scope.saveTime = () ->
      hide = () ->
        $timeout () ->
          scope.saved = no
          scope.err = no
        , 2000
      User.saveProfile(scope.user).then (result) ->
        scope.saved = yes
      , (err) ->
        scope.err = yes
      .finally hide

    scope.pullContacts = () ->
      scope.synching = yes
      User.synchLinkedIn().then (user) ->
        scope.user = user
      , (err) ->
        scope.synchError = yes
      .finally ->
        scope.synching = no
]

app.controller 'ProfileController', [
  'User'
  '$scope'
  (user, scope) ->
    scope.loading = yes
    user.getProfile().then (user) ->
      scope.user = user
    , (err) ->
      scope.error = 'Your profile could not be loaded.'
    .finally () ->
      scope.loading = no
]

