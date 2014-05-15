app = angular.module 'consulted.overview.filters', []

app.filter 'younger', [
  ->
    (input) ->
      input
]

app.filter 'older', [
  ->
    (input) ->
      input
]
