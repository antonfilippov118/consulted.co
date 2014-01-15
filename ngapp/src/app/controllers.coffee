app = angular.module "consulted.controllers", []

app.controller "SignupController", [
  "$scope"
  "User"
  (scope, user) ->
    scope.error = no
    scope.loading = no
    scope.user = {}

    scope.type = "email"

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

app.controller "CategoriesController", [
  "$scope"
  "Categories"
  "$timeout"
  (scope, categories, timeout) ->

    scope.loading = yes
    scope.error   = no

    categories.getCategories().then (categories) ->
      scope.categories = categories
    , (err) ->
      scope.error = "There was an error loading the data."
    .finally () ->
      scope.loading = no
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

    scope.pullContacts = () ->
      scope.synching = yes
      user.synchLinkedIn().then (user) ->
        console.log user
        scope.user = user
      , (err) ->
        scope.synchError = yes
      .finally ->
        scope.synching = no

]

app.controller 'NavigationController', [
  '$scope'
  'User'
  (scope, user) ->
    scope.logout = user.logout
    scope.$on 'event:authchange', ->
      scope.loggedIn = user.isLoggedIn()
]

app.controller "LegalController", [
  "$scope"
  (scope) ->
    console.log "Legal"
]

app.controller "FaqController", [
  "$scope"
  (scope) ->
    console.log "FAQ"
]

app.controller "CareerController", [
  "$scope"
  (scope) ->
    console.log "Career"
]

app.controller "ExpertsController", [
  "$scope"
  "Experts"
  (scope, experts) ->
    scope.error = no
    scope.loading = yes
    experts.getExperts(limit: 25).then (experts) ->
      scope.experts = experts
    , (err) ->
      scope.error = "There was an error fetching the data."
    .finally () ->
      scope.loading = no

]

app.controller "UseCasesController", [
  "$scope"
  (scope) ->
    console.log "Use cases"
]

app.controller "SitemapController", [
  "$scope"
  (scope) ->
    console.log "Sitemap"
]