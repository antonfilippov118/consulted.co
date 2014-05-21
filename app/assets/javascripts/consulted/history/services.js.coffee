app = angular.module 'consulted.history.services', []

app.service 'Type', [
  '$location'
  (location) ->
    isOffered = () ->
      location.path() is '/offered'
    isRequested = () ->
      location.path() is '/requested'

    isOffered: isOffered
    isRequested: isRequested

    setOffered: () ->
      location.path('/offered') unless isOffered()

    setRequested: () ->
      location.path('/requested') unless isRequested()
]

app.service 'Calls', [
  '$http'
  '$q'
  (http, q) ->
    requestPath = '/my-calls/requested.json'
    offeredPath = '/my-calls/offered.json'

    get = (path) ->
      result = q.defer()
      http.get(path).then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise

    getRequested: -> get(requestPath)
    getOffered: -> get(offeredPath)

]
