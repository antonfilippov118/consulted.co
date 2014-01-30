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
