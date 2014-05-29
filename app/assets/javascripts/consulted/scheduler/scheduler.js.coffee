app = angular.module 'consulted.scheduler', ["scheduler"]

app.constant 'HEADER_DATE_FORMAT', 'dddd, DD MMMM YYYY'

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
      monday = week.clone().zone(offset).isoWeekday(1).hour(0).minute(0).second(0).millisecond(0)
      monday.add('d', day - 1).add('m', minutes)
      console.log monday.format()
      monday

    q.all([TimezoneData.getFormattedOffset(), AvailabilityData.get()]).then (data) ->
      [formatted_offset, availabilities] = data

      updateData = () ->
        updateResult = q.defer()
        AvailabilityData.get().then (newAvailabilities) ->
          availabilities = newAvailabilities
          updateResult.resolve newAvailabilities
        updateResult.promise

      result.resolve
        getCurrent: (week) ->
          monday = week.clone().isoWeekday(1).hour(0).minute(0).second(0).millisecond(0)
          sunday = week.clone().isoWeekday(7).hour(23).minute(59).second(59).millisecond(0)
          current = for i in [0...7]
            []
          for availability in availabilities
            start = moment.unix(availability.start).zone(formatted_offset)
            end = moment.unix(availability.end).zone(formatted_offset)

            if (start.isAfter(monday) and end.isBefore(sunday))
              #console.log start.format(), end.format()
              #console.log monday.format(), sunday.format()
              #console.log start.isAfter(monday), end.isBefore(sunday)
              current[start.isoWeekday()].push
                time: [momentToMinutes(start), momentToMinutes(end)]
                data:
                  availability
          current

        update: (week, dayIndex, data, time, recurrence) ->
          updatingResult = q.defer()
          pending = []
          for i in [0..recurrence]
            object =
              availability:
                start: minutesToMoment(time[0], week, dayIndex, formatted_offset).add('d', 7 * i).unix()
                end: minutesToMoment(time[1], week, dayIndex, formatted_offset).add('d', 7 * i).unix()
            object.availability.id = data.id if i is 0
            pending.push http.put('/availabilities', object)
          q.all(pending).then () ->
            updateData().then () ->
              updatingResult.resolve yes
          updatingResult.promise

        add: (week, dayIndex, data, time, recurrence) ->
          addingResult = q.defer()
          pending = []
          for i in [0..recurrence]
            object =
              availability:
                start: minutesToMoment(time[0], week, dayIndex, formatted_offset).add('d', 7 * i).unix()
                end: minutesToMoment(time[1], week, dayIndex, formatted_offset).add('d', 7 * i).unix()
            pending.push http.put("/availabilities", object)
          q.all(pending).then (data) ->
            updateData().then (availabilities) ->
              addingResult.resolve yes

          addingResult.promise

        delete: (data) ->
          deleteResult = q.defer()
          http.delete("/availabilities/#{data.id}").then () ->
            updateData().then () ->
              deleteResult.resolve yes
          deleteResult.promise

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
    getFormattedOffset: () ->
      result = q.defer()
      http.get('/timezone').success (data) ->
        if data?.formatted_offset?
          result.resolve data.formatted_offset
        else
          result.reject "error while getting timezone"
      result.promise

]

app.controller 'ScheduleCtrl', [
  '$scope'
  'Availabilities'
  'HEADER_DATE_FORMAT'
  (scope, Availabilities, Timezone, HEADER_DATE_FORMAT) ->

    scope.next = (event) ->
      scope.currentWeek = scope.currentWeek.clone().add('d', 7)

    scope.prev = (event) ->
      scope.currentWeek = scope.currentWeek.clone().subtract('d', 7) unless scope.firstWeek

    scope.currentWeek = moment()
    scope.firstWeek = no

    Availabilities.getService().then (availabilityService) ->
      scope.events = availabilityService.getCurrent scope.currentWeek

      scope.$watch 'currentWeek', () ->
        scope.firstWeek = moment().isoWeekday(1).isAfter(scope.currentWeek.clone().subtract('d',7))
        scope.from = scope.currentWeek.clone().isoWeekday(1).format('dddd, DD MMMM YYYY')
        scope.to = scope.currentWeek.clone().isoWeekday(7).format('dddd, DD MMMM YYYY')
        scope.events = availabilityService.getCurrent scope.currentWeek


      scope.$on "scheduler.remove", (event, data) ->
        if data.id?
          availabilityService.delete(data).then () ->
            scope.events = availabilityService.getCurrent scope.currentWeek
            CONSULTED.trigger "Deleted availability"

      scope.$on "scheduler.update", (event, data, time, bounds, recurrence) ->
        availabilityService.update(scope.currentWeek, bounds[0], data, time, recurrence).then () ->
          scope.events = availabilityService.getCurrent scope.currentWeek
          CONSULTED.trigger "Availability updated"

      scope.$on "scheduler.add", (event, data, time, bounds, recurrence) ->
        availabilityService.add(scope.currentWeek, bounds[0], data, time, recurrence).then () ->
          scope.events = availabilityService.getCurrent scope.currentWeek
          CONSULTED.trigger "Availability added"
]

