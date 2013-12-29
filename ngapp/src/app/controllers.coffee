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

app.controller "ContactController", [
  "$scope"
  "Contact"
  "User"
  (scope, contact) ->
    scope.error   = no
    scope.message = {}

    scope.contact = () ->
      return if scope.sending is yes
      scope.sending = yes

      contact.submit(scope.message).then (status) ->
        scope.status = status
      , (err) ->
        scope.error = "There was an error sending the contact form."
      .finally () ->
        scope.sending = no







]