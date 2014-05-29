app = angular.module 'consulted.scheduler', ["scheduler"]

app.service 'AvailabilityData', [
  "$http"
  "$q"
  (http, q) ->
    get: () ->
      result = q.defer()
      http.get("/availabilities").success (data) ->
        result.resolve data
      result.promise
]

app.service 'Availabilities', [
  "$http"
  "$q"
  "TimezoneData"
  "AvailabilityData"
  (http, q, TimezoneData, AvailabilityData) ->
    result = q.defer()

    momentToMinutes = (moment) ->
      moment.hour() * 60 + moment.minute()

    q.all([TimezoneData.get(), AvailabilityData.get()]).then (data) ->
      [offset, availabilities] = data

      result.resolve
        getCurrent: (week) ->
          monday = week.clone().isoWeekday(1).hour(0).minute(0).second(0).millisecond(0)
          sunday = week.clone().isoWeekday(7).hour(23).minute(59).second(59).millisecond(0)
          current = for i in [0...7]
            []
          for availability in availabilities
            start = moment.unix availability.start - offset
            end = moment.unix availability.end - offset
            
            if (start.isAfter(monday) and end.isBefore(sunday))
              current[start.isoWeekday()].push
                time: [momentToMinutes(start), momentToMinutes(end)]
                data:
                  availability

          current


    getService: () ->
      result.promise
]

app.service 'TimezoneData', [
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
  (scope, Availabilities, Timezone) ->

    Availabilities.getService().then (availabilityService) ->
      scope.events = availabilityService.getCurrent(moment())

    scope.currentWeek = moment()

    scope.$on "scheduler.remove", (event, data) ->
      scope.log.push "remove #{data.id}"

    scope.$on "scheduler.update", (event, data, time) ->
      scope.log.push "update #{data.id}, #{time[0]} - #{time[1]}"

    scope.$on "scheduler.add", (event, data, time) ->
      scope.log.push "add #{data.id}, #{time[0]} - #{time[1]}"
]

