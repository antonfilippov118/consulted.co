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

app.service "User", [
  "$http"
  "$q"
  (http, q) ->
    reject = () ->
      results = q.defer()
      results.reject()
      results.promise

    signup: (user) ->
      results = q.defer()
      http.post("/users", {user: user}).then (data) ->
        results.resolve data.status
      , (err) ->
        results.reject err

      results.promise

    login: (user) ->
      results = q.defer()
      http.post("/login.json", {user: user}).then (data) ->
        results.resolve data.status
      , (err) ->
        results.reject err

      results.promise

    emailAvailable: (email) ->
      results = q.defer()
      http.get("/users/available?email=#{email}").then (status) ->
        results.resolve yes
      , (err) ->
        results.resolve no

      results.promise





    linkedInLogin: () ->
      reject()

    facebookLogin: () ->
      reject()

    googlePlusLogin: () ->
      reject()
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