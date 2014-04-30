$ ->
  # manual bootstrap, these are separate apps

  offersElement = document.getElementById 'offer_setup'
  angular.bootstrap offersElement, ['consulted.offers']
