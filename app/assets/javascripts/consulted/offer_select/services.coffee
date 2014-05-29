app = angular.module 'consulted.offer_select.services', []

app.service 'Configuration', [
  '$rootElement'
  Configuration = (root) ->
    getSlug: () ->
      root.data 'expert'
    getOffset: () ->
      root.data 'tz-offset'
]

app.service 'ExpertOffers', [
  'Configuration'
  '$http'
  '$q'
  '$rootScope'
  ExpertOffers = (Configuration, http, q, root) ->
    slug = Configuration.getSlug()
    selected = null

    select: (offer) ->
      selected = offer
      root.$broadcast 'offer:change', offer

    selected: (offer) ->
      return no unless selected?
      selected is offer

    getSelected: -> selected

    get: () ->
      result = q.defer()
      http.get("/offers/#{slug}.json").then (response) ->
        result.resolve response.data
      result.promise
]

app.service 'ExpertAvailabilities', [
  '$http'
  '$q'
  'Configuration'
  'ExpertOffers'
  ExpertAvailabilities = (http, q, Configuration) ->
    slug = Configuration.getSlug()
    get: (offer) ->
      result = q.defer()
      http.get("/times/#{slug}/#{offer.slug}.json").then (response) ->
        result.resolve response.data
      result.promise

]

