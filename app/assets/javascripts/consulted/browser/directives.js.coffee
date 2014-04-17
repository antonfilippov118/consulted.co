app = angular.module "consulted.browser.directives", [
  "consulted.browser.controllers"
]

app.directive "lookup", [
  () ->
    replace: yes
    scope: yes
    templateUrl: "lookup"
    controller: 'LookupCtrl'
]

app.directive "browse", [
  () ->
    replace: yes
    scope: yes
    templateUrl: "browse"
    controller: 'BrowseCtrl'
]

app.directive 'bread', [
  () ->
    replace: yes
    scope: yes
    templateUrl: 'bread'
    controller: 'BreadCtrl'

]
