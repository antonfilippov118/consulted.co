app = angular.module "consulted.offers.services", []

app.service "Offers", [
  '$http'
  '$q'
  '$timeout'
  (http, q, timeout) ->
    internalTimer = null
    save = (offers) ->
      http.put('/profile/offers', {offers: offers}).then (response) ->
        console.log response.data
      , (err) ->
        console.log err

    getOffers: () ->
      offers = q.defer()
      http.get('/profile/offers').then (response) ->
        offers.resolve response.data
      , (err) ->
        offers.reject err

      offers.promise

    periodicSave: (offers) ->
      timeout.cancel internalTimer if internalTimer?
      internalTimer = timeout () ->
        save offers
      , 2000




]
