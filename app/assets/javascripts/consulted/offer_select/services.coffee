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
    selected = null

    select: (offer) ->
      selected = offer

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
  ExpertAvailabilities = (http, q, Configuration) ->
    slug = Configuration.getSlug()
    transformed = (data) ->
      data.map (obj) ->
        start_date: moment(obj.start).toDate()
        end_date: moment(obj.end).toDate()

    get: () ->
      result = q.defer()
      http.get("/availabilities/#{slug}.json").then (response) ->
        result.resolve transformed response.data
      result.promise

]

app.service 'SchedulerReadonly', [
  'Configuration'
  'ExpertOffers'
  '$window'
  Scheduler = (Configuration, ExpertOffers, $window) ->
    selectEvent = (id, event) ->
      obj    = scheduler.getEvent id
      expert = Configuration.getSlug()
      offer  = ExpertOffers.getSelected()
      return unless offer

      start  = moment(obj.start_date).format('YYYY-MM-DD')
      $window.location.assign "/offers/#{offer.slug}-with-#{expert}/review/#{start}"

    init: (el) ->
      scheduler.config.readonly = yes
      scheduler.init el[0], new Date, 'week'
      scheduler.templates.event_class = (start, end) ->
        if moment(end).isBefore(moment())
          'past'
        else
          'availability clickable'

      scheduler.attachEvent 'onClick', selectEvent

    addEvents: (events) ->
      scheduler.addEvent event for event in events


]
