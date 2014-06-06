app = angular.module 'consulted.overview.filters', []

app.filter 'reviewable', [
  ->
    (input) ->
      filtered = []
      for call in input
        filtered.push call if call.reviewable
      filtered
]

app.filter 'notReviewable', [
  ->
    (input) ->
      filtered = []
      for call in input
        filtered.push call if !call.reviewable
      filtered
]

app.filter 'younger', [
  ->
    (input, days = 7) ->
      time = moment().add days, 'days'
      filtered = []
      for call in input
        filtered.push call if call.timestamp < time.unix()
      filtered
]

app.filter 'older', [
  ->
    (input, days = 7) ->
      time = moment().add days, 'days'
      filtered = []
      for call in input
        filtered.push call if call.timestamp >= time.unix()
      filtered
]
