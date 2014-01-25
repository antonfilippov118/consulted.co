app = angular.module "consulted.users.controllers", [
  'consulted.users.services'
]


app.controller "SignupController", [
  "$scope"
  "$location"
  "User"
  (scope, location, user) ->
    scope.error = no
    scope.loading = no
    scope.user = {}

    scope.type = "profile"

    scope.signup = () ->
      return if scope.loading is yes
      return if scope.type is "profile"
      scope.loading = yes

      user.signup(scope.user).then (status) ->
        scope.type = 'success'
        scope.errors = no
      , (err) ->
        scope.error  = "There was an error during signup."
        scope.errors = err.data
      .finally () ->
        scope.loading = no

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

    scope.loginWithProfile = (profile) ->
      return unless !!profile or scope.loggingIn is yes
      scope.loggingIn = yes
      switch profile
        when "linkedin" then promise = user.linkedInLogin()
        when "facebook" then promise = user.facebookLogin()
        when "google" then promise = user.googlePlusLogin()

      return unless promise

      promise.then (user) ->
        location.path "/profile/#{user.hash}"
      , (err) ->
        scope.error = "There was an error during login."
      .finally () ->
        scope.loggingIn = no
]
