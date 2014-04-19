app = angular.module 'consulted.browser.services', []

app.service 'Search', [
  '$http'
  '$q'
  (http, q) ->
    do: (term) ->
      result = q.defer()

      http.post('/group/search.json', text: term).then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err

      result.promise






]