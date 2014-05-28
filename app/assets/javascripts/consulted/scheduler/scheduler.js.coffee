app = angular.module 'consulted.scheduler', ["scheduler"]


app.service 'Timezone', [
  '$http'
  '$q'
  (http, q) ->
    get: () ->
      result = q.defer()
      http.get('/timezone').success (data) ->
        if data?.offset?
          result.resolve data.offset
        else
          result.reject "error while getting timezone"
      result.promise
    
]

app.controller 'ScheduleCtrl', [
  '$scope'
  'Availabilities'
  'Timezone'
  (scope, Availabilities, Timezone) ->

    Timezone.get().then (offset) ->
      console.log offset

    scope.currentWeek = moment()

    scope.$on "scheduler.remove", (event, data) ->
      scope.log.push "remove #{data.id}"

    scope.$on "scheduler.update", (event, data, time) ->
      scope.log.push "update #{data.id}, #{time[0]} - #{time[1]}"

    scope.$on "scheduler.add", (event, data, time) ->
      scope.log.push "add #{data.id}, #{time[0]} - #{time[1]}"
    #Availabilities.get().then (events) ->
    #  scope.events = events
]

