$ ->
  # manual bootstrap, these are separate apps

  finderElement = document.getElementById 'consulted_finder'
  angular.bootstrap finderElement, ['consulted.finder']

  categoriesElement = document.getElementById 'consulted_categories'
  angular.bootstrap categoriesElement, ['consulted.categories']

  offersElement = document.getElementById 'consulted_offers'
  angular.bootstrap offersElement, ['consulted.offers']

  schedulerElement = document.getElementById 'consulted_scheduler'
  angular.bootstrap schedulerElement, ['consulted.scheduler']
