app = angular.module 'consulted.offer_select.services', []

app.service 'Configuration', [
  '$rootElement'
  Configuration = (root) ->
    getSlug: () ->
      root.data 'expert'
]

app.service 'ExpertOffers', [
  'Configuration'
  '$http'
  '$q'
  ExpertOffers = (Configuration, http, q) ->
    slug = Configuration.getSlug()
    get: () ->
      result = q.defer()
      http.get("/offers/#{slug}.json").then (response) ->
        result.resolve response.data
      result.promise
]

app.service 'Scheduler', [
  () ->
    init: (el) ->
      scheduler.config.readonly = yes
      scheduler.config.limit_view = yes
      scheduler.config.limit_start = new Date
      scheduler.config.limit_end = (moment().add 1, 'year')
      scheduler.init(el[0], new Date, 'week')
]

