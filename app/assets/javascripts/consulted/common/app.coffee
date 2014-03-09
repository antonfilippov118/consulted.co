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

app.service "AvailabilityData", [
  '$http'
  '$q'
  '$timeout'
  AvailabilityData = (http, q, timeout) ->
    timer = null

    save: (_event) ->
      result = q.defer()
      $timeout.cancel timer if timer?
      $timeout ->
        Saving.show()
        event = angular.copy _event

        if moment.isMoment(event.starts)
          event.starts = event.starts.format()
        if moment.isMoment(event.ends)
          event.ends = event.ends.format()

        http.put('/profile/availabilities', event).then (response) ->
          result.resolve response.data
        , (err) ->
          result.reject err
        .finally () ->
          Saving.hide()
      , 500

      result.promise

    remove: (id) ->
      result = q.defer()
      Saving.show()
      http.delete("/profile/availabilities/#{id}").then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      .finally ->
        Saving.hide()

    getEventsForWeek: (options) ->
      result = q.defer()
      http.get('/profile/availabilities', params: options).then (response) ->
        _data = []
        for day, i in response.data
          events = []
          for event, index in day
            event.ends      = moment(event.ends)
            event.starts    = moment(event.starts)
            event.new_event = no
            events.push event
          _data.push events
        result.resolve _data
      , (err) ->
        result.reject err
      result.promise
]

timeFilters = {
  'minute': "mm"
  'hour': "HH:mm"
  'date': "YYYY-MM-DD"
  'datetime': "YYYY-MM-DD HH:mm:ss"
  'datehour': "YYYY-MM-DD HH:mm"
}

angular.forEach timeFilters, (format, key) ->
  app.filter key, ->
    (input) ->
      if moment.isMoment(input)
        return input.format format
      moment(input).format format

app.filter "week", [() ->
  (input, iso = yes) ->
    input = moment(input) unless moment.isMoment input
    return input.isoWeek() if iso
    return input.week()
]
