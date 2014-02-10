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
        timeout ->
          Saving.hide()
        , 500

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
  '$timeout'
  '$q'
  '$http'
  (Saving, timeout, q, http) ->
    internalTimer = null
    availabilities = []
    http.get("/profile/availabilities").then (response) ->
      availabilities = response.data

    save: (event) ->
      result = q.defer()
      http.put('/profile/availabilities', event).then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise

    get: (starting_day = moment()) ->
      availabilities

    periodicSave: (event)->
      timeout.cancel internalTimer if internalTimer?
      result = q.defer()
      internalTimer = timeout ->
        save(event).then (newEvent) ->
          result.resolve newEvent
        , (err) ->
          result.reject err
      , 2000
      result.promise



]
