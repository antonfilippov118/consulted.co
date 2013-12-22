app = angular.module "consulted", ['templates-app']

app.controller "AppCtrl", ['$scope', (scope) ->
  scope.foo = "New Frontend project"
]

app.directive "testTemplate", [() ->
  scope: yes
  templateUrl: "views/foo.tpl.html"
  link: (scope) ->
    scope.foo = "Bar from Template"
]
