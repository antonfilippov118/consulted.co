app = angular.module "consulted.services", []

app.service "Experts", [
  "$http",
  "$q",
  (http, q) ->
    getRandomExperts: () ->
      results = q.defer()
      http.get("/experts.json").then (data) ->
        results.resolve data.experts
      , (err) ->
        results.reject err

      results.promise
]