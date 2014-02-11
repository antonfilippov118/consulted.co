app = angular.module "consulted.offers.services", [
  'consulted.common.services'
]

app.service "Offers", [
  '$http'
  '$q'
  '$timeout'
  'Saving'
  (http, q, timeout, Saving) ->
    internalTimer = null
    offers        = http.get('/profile/offers')

    save = (offers) ->
      Saving.show()
      http.put('/profile/offers', {offers: offers}).then (response) ->
        return
      .finally () ->
        Saving.hide()

    getOffers: () ->
      result = q.defer()
      offers.then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err

      result.promise

    periodicSave: (offers) ->
      timeout.cancel internalTimer if internalTimer?
      internalTimer = timeout () ->
        save offers
      , 2000
]

app.service "Availabilities", [
  'Saving'
  '$q'
  '$http'
  (Saving, q, http) ->

    save: (_event) ->
      Saving.show()
      result = q.defer()

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
