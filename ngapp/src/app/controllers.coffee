app = angular.module "consulted.controllers", []

app.controller "SignupController", [
  "$scope"
  "User"
  (scope, user) ->
    scope.error = no
    scope.user = {}

    scope.type = "email"

    scope.signup = () ->
      return if scope.saving is yes
      return if scope.type is "profile"
      scope.saving = yes

      user.signup(scope.user).then (status) ->
        scope.success = yes
      , (err) ->
        scope.error = "There was an error during signup."
      .finally () ->
        scope.saving = no

    scope.switch = () ->
      if scope.type is "profile"
        scope.type = "email"
      else
        scope.type = "profile"
]

app.controller "LoginController", [
  "$scope"
  "$location"
  "User"
  (scope, location, user) ->
    scope.error = no

    scope.user = {}

    scope.login = () ->
      return if scope.loggingIn
      scope.loggingIn = yes
      user.login(scope.user).then (user) ->
        location.path "/profile/#{user.hash}"
      , (err) ->
        scope.error = "There was an error during login."
      .finally () ->
        scope.loggingIn = no
]