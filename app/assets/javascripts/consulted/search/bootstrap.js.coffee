$ ->
  # manual bootstrap, these are separate apps

  finderElement = document.getElementById 'consulted_finder'
  angular.bootstrap finderElement, ['consulted.finder']