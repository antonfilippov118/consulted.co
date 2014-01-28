app =  angular.module "consulted.offers", [
  'consulted.offers.controllers'
  'consulted.offers.filters'
  'ngRoute'
]

app.config [
  '$routeProvider',
  (routeProvider) ->
    routeProvider.when "/offer_your_time",
      controller: "OfferController"
      templateUrl: "views/offers/offer_your_time.tpl.html"

]