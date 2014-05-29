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
    minutesToMoment = (minutes, week, day, offset) ->
      monday = week.clone().isoWeekday(1).hour(0).minute(0).second(0).millisecond(0)
      monday.add('d', day - 1).add('m', minutes).add('s', offset)

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
              console.log start.format(), end.format()
              console.log monday.format(), sunday.format()
              console.log start.isAfter(monday), end.isBefore(sunday)
              current[start.isoWeekday()].push
                time: [momentToMinutes(start), momentToMinutes(end)]
                data:
                  availability

          current
        update: (week, dayIndex, data, time) ->
          result = q.defer()
          object =
            availability:
              id: data.id
              start: minutesToMoment(time[0], week, dayIndex, offset).unix()
              end: minutesToMoment(time[1], week, dayIndex, offset).unix()
          http.put('/availabilities', object).then (data) ->
            result.resolve yes
          result.promise



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
    
    scope.currentWeek = moment()

    Availabilities.getService().then (availabilityService) ->
      scope.events = availabilityService.getCurrent(moment())


      scope.$on "scheduler.remove", (event, data) ->
        console.log "remove ", data

      scope.$on "scheduler.update", (event, data, time, bounds) ->
        availabilityService.update(scope.currentWeek, bounds[0], data, time).then () ->
          CONSULTED.trigger "Availability updated"

      scope.$on "scheduler.add", (event, data, time) ->

        console.log "add ", data, time
]

