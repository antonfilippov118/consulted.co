app = angular.module "consulted.scheduler", [
  'ui.bootstrap'
  'consulted.common'
  'consulted.calendar'
]

app.run [
  '$rootElement'
  ($rootElement) ->
    newEl = $('<div component></div>')
    $rootElement.append newEl
]

app.directive 'component', [
  () ->
    replace: yes
    controller: 'SchedulerCtrl'
    templateUrl: 'scheduler'
]

app.controller "SchedulerCtrl", [
  '$scope'
  'UserData'
  '$modal'
  SchedulerCtrl = (scope, UserData, modal) ->

    fetch = () ->
      scope.loading = yes
      UserData.getSettings().then (data) ->
        scope.settings = data
      .finally () ->
        scope.loading = no

    scope.changeTimezone = () ->
      modalInstance = modal.open
        templateUrl: 'modalWindow'
        controller: 'WindowCtrl'

      modalInstance.result.then process

    process = (zone) ->
      scope.timezone = zone
      UserData.save(user: { timezone: zone.name }).then (response) ->
        fetch()
        # update times in calendar

    fetch()
]

app.controller 'WindowCtrl', [
  '$scope'
  '$modalInstance'
  'UserData'
  WindowCtrl = (scope, modalInstance, UserData) ->
    scope.loading = yes

    UserData.getAvailableZones().then (zones) ->
      scope.zones = zones
    .finally () ->
      scope.loading = no

    UserData.getTimezone().then (zone) ->
      scope.selected = zone

    scope.use = (selected) ->
      modalInstance.close selected

]
