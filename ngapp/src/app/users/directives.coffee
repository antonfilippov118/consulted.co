app = angular.module "consulted.users.directives", []

app.directive "checkEmail", [
  '$timeout',
  '$http',
  'User',
  (timeout, http, user) ->
    require: "ngModel"
    restrict: "A"
    link: (scope, el, attrs, ctrl) ->
      checking = null
      ctrl.$parsers.push (viewValue) ->
        timeout.cancel checking if checking?
        checking = timeout ->
          ctrl.$setValidity 'emailAvailable', yes

          if ctrl.$valid
            ctrl.$setValidity 'checkingEmail', no
            if viewValue isnt "" && viewValue isnt undefined
              user.emailAvailable(viewValue).then (result) ->
                ctrl.$setValidity 'emailAvailable', result
                ctrl.$setValidity 'checkingEmail', result
            else
              ctrl.$setValidity 'emailAvailable', yes
              ctrl.$setValidity 'checkingEmail', yes
        , 500
        return viewValue
]

app.directive "passwordConfirmation", [
  () ->
    require: 'ngModel'
    restrict: 'A'
    scope:
      passwordConfirmation: '='
    link: (scope, el, attrs, ctrl) ->
      scope.$watch () ->
        if scope.passwordConfirmation || ctrl.$viewValue
          return "#{scope.passwordConfirmation}_#{ctrl.$viewValue}"
        return undefined
      , (value) ->
        if value
          ctrl.$parsers.unshift (viewValue) ->
            origin = scope.passwordConfirmation
            if origin isnt viewValue
              ctrl.$setValidity 'passwordConfirmation', no
              return undefined
            else
              ctrl.$setValidity 'passwordConfirmation', yes
              return viewValue
]