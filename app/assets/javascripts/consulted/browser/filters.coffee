app = angular.module 'consulted.browser.filters', []

app.filter 'prioritized', [
  () ->
    (input, prioritized = yes) ->
      return [] unless angular.isArray input
      input.filter (item) ->
        item.prioritized is prioritized




]
