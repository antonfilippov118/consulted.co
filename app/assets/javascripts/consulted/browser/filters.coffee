app = angular.module 'consulted.browser.filters', []

app.filter 'prioritized', [
  () ->
    (input, prioritized = yes) ->
      return [] unless angular.isArray input
      input.filter (item) ->
        item.prioritized is prioritized && item.unprioritized is no
]

app.filter 'unprioritized', [
  () ->
    (input) ->
      return [] unless angular.isArray input
      input.filter (item) ->
        item.unprioritized is yes


]
