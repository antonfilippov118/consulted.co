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
      scope.
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