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
            start = moment.unix availability.start - offset
            end = moment.unix availability.end - offset
            
            if (start.isAfter(monday) and end.isBefore(sunday))
              #console.log start.format(), end.format()
              #console.log monday.format(), sunday.format()
              #console.log start.isAfter(monday), end.isBefore(sunday)
              current[start.isoWeekday()].push
                time: [momentToMinutes(start), momentToMinutes(end)]
                data:
                  availability
          current

        
        update: (week, dayIndex, data, time) ->
          updatingResult = q.defer()
          object =
            availability:
              id: data.id
              start: minutesToMoment(time[0], week, dayIndex, offset).unix()
              end: minutesToMoment(time[1], week, dayIndex, offset).unix()
          http.put('/availabilities', object).then (data) ->
            updatingResult.resolve yes
          updatingResult.promise

        add: (week, dayIndex, data, time) ->
          addingResult = q.defer()
          object =
            availability:
              start: minutesToMoment(time[0], week, dayIndex, offset).unix()
              end: minutesToMoment(time[1], week, dayIndex, offset).unix()
          http.put("/availabilities", object).then (data) ->      
            updateData().then (availabilities) ->
              addingResult.resolve yes
              return
            return
          
          addingResult.promise

        delete: (data) ->
          result = q.defer()
          http.delete("/availabilities/#{data.id}").then () ->
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
    
    

    scope.$watch 'currentWeek', () ->
      
      scope.firstWeek = moment().isoWeekday(1).isAfter(scope.currentWeek.clone().subtract('d',7))
      console.log "currentWeek changed", scope.firstWeek

    scope.currentWeek = moment()
    scope.firstWeek = no

    Availabilities.getService().then (availabilityService) ->
      scope.events = availabilityService.getCurrent scope.currentWeek


      scope.$on "scheduler.remove", (event, data) ->
        if data.id?
          availabilityService.delete(data).then () ->
            CONSULTED.trigger "Deleted availability"

      scope.$on "scheduler.update", (event, data, time, bounds) ->
        availabilityService.update(scope.currentWeek, bounds[0], data, time).then () ->
          CONSULTED.trigger "Availability updated"

      scope.$on "scheduler.add", (event, data, time, bounds) ->
        availabilityService.add(scope.currentWeek, bounds[0], data, time).then () ->
          scope.events = availabilityService.getCurrent scope.currentWeek
          CONSULTED.trigger "Availability added"
]

