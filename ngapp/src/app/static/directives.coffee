app = angular.module "consulted.static.directives", []

primitives = [
  "marketing"
  "startpage"
  "use_case_preview"
  "how_it_works"
  "satisfaction"
  "description"
  "graph_description"
]

buildPrimitive = (name) ->
  camelize = (string) ->
    string.replace /\_([a-z])/g, (g) -> g[1].toUpperCase()

  app.directive "#{camelize name}", [
    () ->
      scope: yes
      replace: yes
      templateUrl: "views/static/#{name}.tpl.html"
  ]

buildPrimitive name for name in primitives
