app = angular.module "consulted.directives", [
  "consulted.services"
]

app.directive "consultedStartpage", [
  () ->
    scope: yes
    replace: yes
    templateUrl: "views/start.tpl.html"
]

app.directive "consultedMarketing", [
  () ->
    replace: yes
    scope: yes
    templateUrl: "views/marketing_preview.tpl.html"
]

app.directive "consultedExpertsPreview", [
  'Experts',
  (experts) ->
    replace: yes
    scope: yes
    templateUrl: "views/experts_preview.tpl.html"
    link: (scope) ->
      scope.error = no
      scope.loading = yes
      experts.getRandomExperts().then (data) ->
        scope.experts = data
      , (err) ->
        scope.error = "There was an error loading the data."
        scope.experts = []
      .finally () ->
        scope.loading = no
]
