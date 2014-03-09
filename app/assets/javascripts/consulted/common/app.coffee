app = angular.module 'consulted.common', []

app.service 'GroupData', [
  '$http'
  '$q'
  GroupData = (http, q) ->
    groups = http.get('/groups.json')
    getGroups: () ->
      result = q.defer()
      groups.then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise
    findGroup: (id) ->
      result = q.defer()
      groups.then (response) ->
        {data} = response
        find = (data, id) ->
          for group in data
            if group.id is id
              return group
            found = find group.children, id
            return found if found

        group = find data, id
        result.resolve find data, id

      result.promise
]

app.service 'OfferData', [
  '$http'
  '$q'
  OfferData = (http, q) ->

    getOffers: () ->
      result = q.defer()
      http.get('/offers/list.json').then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise
    save: (offer) ->
      result = q.defer()
      http.put('/offers.json', offer).then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise
]

app.service 'UserData', [
  '$http'
  '$q'
  UserData = (http, q) ->
    zone    = {}
    zones   = {}
    _offset = {}

    getSettings: () ->
      result  = q.defer()
      zone    = q.defer()
      zones   = q.defer()
      _offset = q.defer()
      http.get('/settings.json').then (response) ->
        {zones_available, timezone, offset} = response.data
        zones.resolve zones_available
        zone.resolve timezone
        _offset.resolve offset
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise

    getAvailableZones: () ->
      zones.promise

    getTimezone: () ->
      zone.promise

    getOffset: () ->
      _offset.promise

    save: (user) ->
      result = q.defer()
      http.put('/settings/timezone.json', user).then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise
]
