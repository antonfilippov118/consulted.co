app = angular.module "consulted.groups.services", []

app.service "Groups", [
  "$http"
  "$q"
  (http, q) ->
    groups = http.get("/groups")

    getGroups: () ->
      results = q.defer()
      groups.then (response) ->
        results.resolve response.data
      , (err) ->
        results.reject err

      results.promise
]
