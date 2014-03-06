$ ->
  # manual bootstrap, these are separate apps

  finderElement = document.getElementById 'consulted_finder'
  angular.bootstrap finderElement, ['consulted.finder']

  categoriesElement = document.getElementById 'consulted_categories'
  angular.bootstrap categoriesElement, ['consulted.categories']

  categoriesElement = document.getElementById 'consulted_offers'
  angular.bootstrap categoriesElement, ['consulted.offers']
