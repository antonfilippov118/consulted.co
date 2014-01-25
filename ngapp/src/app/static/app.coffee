app = angular.module "consulted.static", [
  'consulted.static.directives'
  'consulted.static.controllers'
  'consulted.static.startpage'
  'ngRoute'
]

app.config [
  "$routeProvider"
  (routeProvider) ->
    static_content = [
      'contact'
      "use_cases"
      "faq"
      "career"
      "sitemap"
      "legal"
    ]

    for page in static_content
      camelize = (string) ->
        string.replace /\_([a-z])/g, (g) -> g[1].toUpperCase()

      name = "#{page[0].toUpperCase()}#{page.substr(1)}"
      routeProvider.when "/#{page}",
        templateUrl: "views/static/#{page}.tpl.html"
        controller: "#{camelize name}Controller"
]
