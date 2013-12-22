app = angular.module "consulted.directives", []

app.directive "consultedStartpage",
  [() ->
    scope: yes
    templateUrl: "views/start.tpl.html"
  ]