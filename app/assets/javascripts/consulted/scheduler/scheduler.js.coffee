app = angular.module 'consulted.scheduler', ["scheduler"]

###
app.service 'Scheduler', [
  'Availabilities'
  (Availabilities) ->
    find = (id) -> scheduler.getEvent id

    update = (id, event) ->
      _event = find(id)
      return unless _event
      _event._id = event.id
      scheduler.updateEvent id

    attachEvents = ->
      scheduler.attachEvent 'onEventChanged', (id, _) ->
        Availabilities.send(find(id)).then () ->
          CONSULTED.trigger 'Availability updated.'

      scheduler.attachEvent 'onEventAdded', (id, _) ->
        obj = find id
        return if obj.created
        Availabilities.send(obj).then (event) ->
          update id, event
          CONSULTED.trigger 'Availability added.'

      scheduler.attachEvent 'onBeforeEventDelete', (id) ->
        Availabilities.delete(find(id)).then () ->
          CONSULTED.trigger 'Availability removed.'
        yes

    detachEvents = ->
      scheduler.detachAllEvents()

    init: (el) ->
      scheduler.init el[0], moment().toDate(), 'week'
      scheduler.config.event_duration = 30
      scheduler.templates.event_class = -> "availability"
      scheduler.config.touch = 'force'
      scheduler.config.limit_view = yes
      scheduler.config.limit_start = new Date()
      scheduler.config.limit_end = (moment().add 365, 'days').toDate()
      scheduler.templates.event_text = -> ''
      scheduler.config.icons_select = ["icon_delete"]
      scheduler.locale.labels.confirm_deleting = null

      attachEvents()

    clear: () ->
      scheduler.clearAll()

    addEvents: (events) ->
      scheduler.addEvent event for event in events

]
###

app.controller 'ScheduleCtrl', [
  '$scope'
  'Availabilities'
  (scope, Availabilities) ->
    max = 24 * 60 
    scope.events = for i in [0...7]
      []

    scope.log = []

    scope.add = (event) ->
      scope.addRandomEvent()
      event.preventDefault()

    scope.addRandomEvent = () ->
      day = Math.floor Math.random() * 7
      start = 5 * Math.floor Math.random() * (max / 5)
      scope.events[day].push 
        time: [start, start + 15]
        data:
          id: Math.round Math.random() * 1000

    for i in [0...3]
      scope.addRandomEvent()


    scope.currentWeek = moment()

    console.log scope.currentWeek
    console.log scope.events

    scope.$on "scheduler.remove", (event, data) ->
      scope.log.push "remove #{data.id}"

    scope.$on "scheduler.update", (event, data, time) ->
      scope.log.push "update #{data.id}, #{time[0]} - #{time[1]}"

    scope.$on "scheduler.add", (event, data, time) ->
      scope.log.push "add #{data.id}, #{time[0]} - #{time[1]}"
    #Availabilities.get().then (events) ->
    #  scope.events = events
]


app.service 'Availabilities', [
  '$http'
  '$q'
  (http, q) ->

    transformed = (data) ->
      data.map (obj) ->
        start_date: moment(obj.start).toDate()
        end_date: moment(obj.end).toDate()
        _id: obj.id
        created: yes

    transform = (event) ->
      id: event._id
      start: +event.start_date
      end: +event.end_date

    get: () ->
      result = q.defer()
      http.get('/availabilities.json').then (response) ->
        result.resolve transformed response.data
      result.promise

    delete: (event) ->
      return unless event
      return unless event._id
      result = q.defer()
      http.delete("/availabilities/#{event._id}.json").then (response) ->
        result.resolve response.data
      result.promise

    send: (event) ->
      result = q.defer()
      http.put('/availabilities.json', availability: transform(event)).then (response) ->
        result.resolve response.data
      result.promise

]
