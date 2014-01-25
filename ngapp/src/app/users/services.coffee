app = angular.module "consulted.users.services", []

app.service "User", [
  "$http"
  "$q"
  "$rootScope"
  "$location"
  (http, q, rootScope, location) ->

    loggedIn = no
    _user    = {}

    rootScope.$on 'event:authchange', (scope, value) ->
      loggedIn = value

    rootScope.$on 'event:unauthorized', () ->
      loggedIn = no

    signup: (user) ->
      results = q.defer()
      http.post("/users", {user: user}).then (data) ->
        results.resolve data.status
      , (err) ->
        results.reject err

      results.promise

    login: (user) ->
      results = q.defer()
      http.post("/users/sign_in", {user: user}).then (data) ->
        results.resolve data.status
        loggedIn = yes
      , (err) ->
        results.reject err

      results.promise

    isLoggedIn: () ->
      loggedIn

    logout: () ->
      result = q.defer()
      http.delete('/users/sign_out').then (response) ->
        result.resolve yes
      , (err) ->
        result.reject no
      .finally ->
        location.path "/"
        rootScope.$broadcast 'event:authchange', no

      result.promise

    getProfile: () ->
      user = q.defer()
      http.get('/profile').then (response) ->
        _user = response.data
        user.resolve response.data

        rootScope.$broadcast 'event:authchange', yes
      , (err) ->
        user.reject err

      user.promise

    saveProfile: (user) ->
      result = q.defer()
      http(method: 'PATCH', url: '/profile', data: user).then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err

      result.promise

    emailAvailable: (email) ->
      results = q.defer()
      http.get("/users/available?email=#{email}").then (status) ->
        results.resolve yes
      , (err) ->
        results.resolve no

      results.promise

    synchLinkedIn: () ->
      results = q.defer()
      http.post("/synch").then (response) ->
        results.resolve response.data
      , (err) ->
        results.reject err

      results.promise

    getExperts: () ->
      results = q.defer()
      results.reject []
      results.promise

    getTestimonials: ->
      results = q.defer()
      results.reject []

      results.promise
]


app.service "Contact", [
  "$http"
  "$q"
  (http, q) ->
    submit: (message) ->
      results = q.defer()
      http.post("/contact", message).then (data) ->
        results.resolve data.data
      , (err) ->
        results.reject err
      results.promise
]
