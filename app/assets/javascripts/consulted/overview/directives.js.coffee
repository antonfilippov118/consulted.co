app = angular.module 'consulted.overview.directives', [
  'ui.bootstrap'
]

app.directive 'call', [
  '$modal'
  CallDirective = (modal) ->
    replace: yes
    templateUrl: 'call'
    scope:
      call: "="
    link: (scope) ->
      scope.cancel = (call) ->
        modal.open
          templateUrl: 'cancel'
          controller: 'CancelCtrl'
          backdrop: 'static'
          resolve:
            call: -> call

      scope.confirm = (call) ->
        modal.open
          templateUrl: 'confirm'
          controller: 'ConfirmCtrl'
          backdrop: 'static'
          resolve:
            call: -> call

      scope.review = (call) ->
        modal.open
          templateUrl: 'review'
          controller: 'ReviewCtrl'
          backdrop: 'static'
          resolve:
            call: -> call
]

app.directive 'noCalls', [
  () ->
    replace: yes
    templateUrl: 'no_call'
    scope:
      text: '@'
]
