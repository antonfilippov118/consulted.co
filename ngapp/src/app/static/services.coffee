app = angular.module "consulted.static.services", []

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