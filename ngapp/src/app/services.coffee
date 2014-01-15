app = angular.module "consulted.services", []

app.service "Experts", [
  "$http"
  "$q"
  (http, q) ->
    getExperts: () ->
      results = q.defer()
      http.get("/experts.json").then (data) ->
        results.resolve data.experts
      , (err) ->
        results.reject err

      results.promise

    getTestimonials: ->
      results = q.defer()
      http.get("/testimonials.json").then (data) ->
        results.resolve data.testimonials
      , (err) ->
        results.reject err

      results.promise
]

app.factory "User", [
  "$http"
  "$q"
  (http, q) ->

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
        loggedIn = no
      , (err) ->
        result.reject no

      result.promise

    getProfile: () ->
      user = q.defer()
      http.get('/profile').then (response) ->
        loggedIn = yes
        user.resolve response.data
      , (err) ->
        user.reject err

      user.promise

    emailAvailable: (email) ->
      results = q.defer()
      http.get("/users/available?email=#{email}").then (status) ->
        results.resolve yes
      , (err) ->
        results.resolve no

      results.promise
]

app.factory "Categories", [
  "$http"
  "$q"
  (http, q) ->
    categories = http.get("/categories.json")

    getCategories: () ->
      results = q.defer()
      categories.then (data) ->
        results.resolve data.categories
      , (err) ->
        results.reject err

      results.promise

    getGroups: () ->
      results = q.defer()
      categories.then (data) ->
        results.resolve data.groups
      , (err) ->
        results.reject err

      results.promise
]

app.service "Contact", [
  "$http"
  "$q"
  (http, q) ->
    submit: (message) ->
      results = q.defer()
      http.post("/contact.json", message).then (data) ->
        results.resolve data.data
      , (err) ->
        results.reject err
      results.promise
]