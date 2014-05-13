app = angular.module 'consulted.offers.directives', [
  'consulted.offers.controllers'
  'consulted.browser.controllers'
]

app.directive 'categories', [
  () ->
    replace: yes
    controller: 'CategoriesCtrl'
    templateUrl: 'categories'
]

app.directive 'editor', [
  () ->
    replace: yes
    controller: 'EditorCtrl'
    templateUrl: 'editor'
]

app.directive 'rate', [
  () ->
    replace: no
    template: '<span style="width:50px;display:inline-block;"><strong>${{amount}}</strong></span>'
    scope:
      rate: "="
      fee: "="
    link: (scope) ->
      scope.$watch 'rate', (rate) -> calc rate

      calc = (rate) ->
        {fee} = scope
        amount = Math.floor(rate - (rate * fee/100))
        amount = 0 if isNaN amount
        scope.amount = amount

]

app.directive 'serviceOffering', [
  '$modal'
  (modal) ->
    replace: yes
    templateUrl: 'offering'
    scope:
      group: "=serviceOffering"
      offers: "="
    controller: 'OfferCtrl'
    link: (scope) ->
      scope.learn = (group) ->
        modalInstance = modal.open
          templateUrl: 'learn'
          controller: 'WindowCtrl'
          windowClass: 'modal-learn'
          resolve:
            group: -> group.slug
            browse: -> no
      scope.selected = (offer) ->
        offer.slug in (scope.offers.map (o) -> o.slug)
]

app.directive 'ionRange', [
  () ->
    scope:
      min: '='
      max: '='
    require: '?ngModel'
    link: (scope, el, attrs, ngModel) ->
      apply = (obj) ->
        scope.$apply () ->
          ngModel.$setViewValue obj.fromNumber

      build = (value) ->
        {min, max} = scope
        el.ionRangeSlider
          type: 'single'
          min: min
          max: max
          postfix: do -> if attrs.postfix then " #{attrs.postfix}" else undefined
          onFinish: apply
        .ionRangeSlider 'update', from: value

      scope.$watch () ->
        ngModel.$modelValue
      , (newValue) ->
        return unless newValue
        build newValue






]
