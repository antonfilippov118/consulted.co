app = angular.module "consulted.directives", [
  "consulted.services"
]

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

  directiveName = "#{name[0].toUpperCase()}#{ name.substr(1)}"
  app.directive "consulted#{camelize directiveName}", [
    () ->
      scope: yes
      replace: yes
      templateUrl: "views/#{name}.tpl.html"
  ]

buildPrimitive name for name in primitives

app.directive "consultedExpertPreview", [
  'Experts',
  (experts) ->
    replace: yes
    scope: yes
    templateUrl: "views/experts_preview.tpl.html"
    link: (scope) ->
      scope.error = no
      scope.loading = yes
      experts.getExperts().then (data) ->
        scope.experts = data
      , (err) ->
        scope.error = "There was an error loading the data."
        scope.experts = []
      .finally () ->
        scope.loading = no
]

app.directive "consultedCategoryPreview", [
  "Categories",
  (categories) ->
    replace: yes
    templateUrl: "views/category_preview.tpl.html"
    scope: yes
    link: (scope) ->
      scope.error   = no
      scope.loading = yes

      categories.getCategories().then (data) ->
        scope.categories = data
      , (err) ->
        scope.error = "There was an error loading the data."
      .finally () ->
        scope.loading = no
]

app.directive "consultedGroupPreview", [
  "Categories",
  (categories) ->
    replace: yes
    templateUrl: "views/group_preview.tpl.html"
    scope: yes
    link: (scope) ->
      scope.error   = no
      scope.loading = yes

      categories.getGroups().then (data) ->
        scope.categories = data
      , (err) ->
        scope.error = "There was an error loading the data."
      .finally () ->
        scope.loading = no
]

app.directive "consultedTestimonials", [
  "Experts",
  (experts) ->
    replace: yes
    templateUrl: "views/testimonials.tpl.html"
    scope: yes
    link: (scope) ->
      scope.error   = no
      scope.loading = yes

      experts.getTestimonials().then (data) ->
        scope.experts = data
      , (err) ->
        scope.error = "There was an error loading the data."
      .finally () ->
        scope.loading = no
]



