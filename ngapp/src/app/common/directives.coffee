app = angular.module "consulted.common.directives", []

app.directive "errorLoading", [
  () ->
    scope: no
    replace: yes
    templateUrl: "views/common/error_loading.tpl.html"
]