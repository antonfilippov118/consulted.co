app = angular.module 'consulted.booking.services', []

app.service 'Offer', [
  '$http'
  '$q'
  '$rootElement'
  (http, q, root) ->
    offer_id = root.data 'offer'
    get: () ->
      result = q.defer()
      http.get("/offers/#{offer_id}/show").then (response) ->
        result.resolve response.data
      result.promise

]

app.service 'Times', [
  '$http'
  '$q'
  (http, q) ->
    get: (offer) ->
      result = q.defer()
      http.get("/times/#{offer.expert.slug}/#{offer.slug}").then (response) ->
        result.resolve response.data
      result.promise

]

app.service 'Book', [
  '$http'
  '$q'
  '$rootElement'
  (http, q, root) ->
    expert = $('#expert_id').val()
    offer  = root.data 'offer'
    confirm: (request) ->
      data = angular.copy request
      data.active_from = moment.utc(data.active_from).format()
      data.expert = expert
      data.offer  = offer
      result = q.defer()
      http.post("/offers", call: data).then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise
]

app.service 'Storage', [
  () ->
    expert = $('#expert_slug').val()
    getTime: () ->
      time = sessionStorage.getItem "#{expert}:time"
      if time
        moment(time)
      else
        false
]
