app = angular.module "consulted.static.startpage", []

app.directive "expertPreview", [
  'User'
  (User) ->
    replace: yes
    scope: yes
    templateUrl: "views/static/experts_preview.tpl.html"
    link: (scope) ->
      scope.error = no
      scope.loading = yes
      User.getExperts().then (data) ->
        scope.experts = data
      , (err) ->
        scope.error = "There was an error loading the data."
        scope.experts = []
      .finally () ->
        scope.loading = no
]


app.directive "categoryPreview", [
  "Groups"
  (Groups) ->
    replace: yes
    templateUrl: "views/static/category_preview.tpl.html"
    scope: yes
    link: (scope) ->
      scope.error   = no
      scope.loading = yes

      Groups.getGroups().then (data) ->
        scope.categories = data
      , (err) ->
        scope.error = "There was an error loading the data."
      .finally () ->
        scope.loading = no
]

app.directive "groupPreview", [
  "Groups",
  (Groups) ->
    replace: yes
    templateUrl: "views/static/group_preview.tpl.html"
    scope: yes
    link: (scope) ->
      scope.error   = no
      scope.loading = yes

      Groups.getGroups().then (data) ->
        scope.categories = data
      , (err) ->
        scope.error = "There was an error loading the data."
      .finally () ->
        scope.loading = no
]

app.directive "testimonials", [
  "User",
  (User) ->
    replace: yes
    templateUrl: "views/static/testimonials.tpl.html"
    scope: yes
    link: (scope) ->
      scope.error   = no
      scope.loading = yes

      User.getTestimonials().then (data) ->
        scope.users = data
      , (err) ->
        scope.error = "There was an error loading the data."
      .finally () ->
        scope.loading = no
]