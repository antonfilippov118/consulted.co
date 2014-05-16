app = angular.module 'consulted.overview.services', []

app.service 'Call', [
  '$http'
  '$q'
  '$rootScope'
  (http, q, root) ->

    reload = () ->
      root.$broadcast 'reload:calls'

    getCalls: () ->
      result = q.defer()
      http.get('/calls.json').then (response) ->
        result.resolve response.data
      result.promise

    cancel: (call) ->
      result = q.defer()
      http.delete("/calls/#{call.id}/cancel").then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err.error
      .finally reload
      result.promise

    confirm: (call) ->
      result = q.defer()
      http.put("/calls/#{call.id}/confirm").then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err.error
      .finally reload
      result.promise

]
