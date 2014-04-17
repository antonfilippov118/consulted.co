$ ->
  # manual bootstrap, these are separate apps

  offersElement = document.getElementById 'consulted_offers'
  angular.bootstrap offersElement, ['consulted.offers']

  schedulerElement = document.getElementById 'consulted_scheduler'
  angular.bootstrap schedulerElement, ['consulted.scheduler']
