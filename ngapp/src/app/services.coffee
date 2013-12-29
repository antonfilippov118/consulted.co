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
        resultes.resolve data.testimonials
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
      http.post("/signup.json", {user: user}).then (data) ->
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
  () ->
    send: (message) ->
      console.log "Message sent!"
]