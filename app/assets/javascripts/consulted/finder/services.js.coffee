app = angular.module 'consulted.finder.services', []

app.service 'Configuration', [
  () ->
    _group = false
    setGroup: (group) ->
      _group = group
    getGroup: -> _group
]

app.service 'Language', [
  'Search'
  (Search) ->
    activeLanguages = []
    defaults = ['english', 'mandarin', 'spanish', 'arabic', 'german']
    allActive = yes

    getLanguages: () -> defaults

    isActive: (lang) ->
      lang in activeLanguages

    getCurrent: ->
      return ['All'] if allActive
      activeLanguages

    allActive: -> allActive

    toggleAll: () ->
      allActive = !allActive
      if allActive
        activeLanguages = []
        Search.trigger languages: defaults

    toggle: (lang) ->
      allActive = no
      idx = activeLanguages.indexOf lang
      if idx > -1
        activeLanguages.splice idx, 1
      else
        activeLanguages.push lang
      Search.trigger languages: activeLanguages

]

app.service 'Tag', [
  'Search'
  (Search) ->
    currentTags = []

    trigger = () ->
      Search.trigger tags: currentTags

    getTags: () -> currentTags

    add: (tag) ->
      currentTags.push tag unless tag in currentTags
      trigger()

    remove: (tag) ->
      idx = currentTags.indexOf tag
      if idx > -1
        currentTags.splice idx, 1
        trigger()
]

app.service 'Continent', [
  'Search'
  (Search) ->

    activeContinents = []
    defaults = [
        "Europe"
        "Asia"
        "North America"
        "Africa"
        "Antarctica"
        "South America"
        "Australia"
    ]
    allActive = yes

    trigger = (opts = { continents: activeContinents }) ->
      Search.trigger opts

    getContinents: () -> defaults

    getCurrent: ->
      return ['All'] if allActive
      activeContinents

    isActive: (continent) ->
      continent in activeContinents

    allActive: -> allActive

    toggleAll: () ->
      allActive = !allActive
      if allActive
        activeContinents = []
        trigger continents: defaults

    toggle: (continent) ->
      allActive = no
      idx = activeContinents.indexOf continent
      if idx > -1
        activeContinents.splice idx, 1
      else
        activeContinents.push continent
      trigger()
]

app.service 'Date', [
  'Search'
  Date = (Search) ->
    fortnight = yes

    days = []

    selected = (day) ->
      return no if fortnight is yes
      for _day in days
        if day.isSame _day, 'date'
          return yes
      no

    trigger = () ->
      if fortnight
        data = { days: [] }
      else
        data = { days: days.map (day) -> day.format 'YYYY-MM-DD' }
      Search.trigger(data)

    availableDays: () ->
      [0..6].map (days) ->
        moment().add days, 'day'

    fortnight: (bool) ->
      fortnight = bool
      days = [] if fortnight
      trigger()

    isFortnight: -> fortnight

    toggle: (day) ->
      fortnight = no
      idx = days.indexOf day
      if idx > -1
        days.splice idx, 1
      else
        days.push day
      fortnight = days.length is 0
      trigger()

    selected: selected

]

app.service 'Time', [
  'Search'
  Time = (Search) ->
    allDay = yes
    times = []

    selected = (time) ->
      return no if allDay
      time in times

    trigger = () ->
      if allDay
        data =
          time_of_day: []
      else
        data =
          time_of_day: times.map (obj) -> { from: obj.from, to: obj.to }
      Search.trigger data

    availableTimes: -> [
      name: 'until 6am'
      from: 0
      to: 6
    ,
      name: '6am-8am'
      from: 6
      to: 8
    ,
      name: '8am-10am'
      from: 8
      to: 10
    ,
      name: '10am-12pm'
      from: 10
      to: 12
    ,
      name: '12pm-2pm'
      from: 12
      to: 14
    ,
      name: '2pm-4pm'
      from: 14
      to: 16
    ,
      name: '4pm-6pm'
      from: 16
      to: 18
    ,
      name: '6pm-8pm'
      from: 18
      to: 20
    ,
      name: 'after 8pm'
      from: 20
      to: 0
    ]

    isAllDay: -> allDay
    allDay: (bool) ->
      allDay = bool
      times  = [] if allDay
      trigger()

    toggle: (time) ->
      idx = times.indexOf time
      if idx > -1
        times.splice idx, 1
      else
        times.push time
      allDay = times.length is 0
      trigger()

    selected: selected


]

app.service 'Bookmark', [
  'Search'
  '$http'
  Bookmark = (Search, http) ->
    bookmark = no
    toggle: () ->
      bookmark = !bookmark
      Search.trigger bookmark: bookmark
    isActive: -> bookmark

    send: (expert) ->
      http.put("/favorites/#{expert.id}")

]

app.service 'Rate', [
  'Search'
  (Search) ->
    current_rate = {}

    trigger = () ->
      Search.trigger rate_lower: current_rate.from, rate_upper: current_rate.to

    defaults =
      from: 0
      to: 1000

    set: (from, to)->
      current_rate.from = from
      current_rate.to = to
      trigger()

    getCurrent: ->
      unless current_rate.from and current_rate.to
        return defaults
      current_rate
]
app.service 'Experience', [
  'Search'
  (Search) ->
    current_exp = {}

    trigger = () ->
      Search.trigger experience_upper: current_exp.to, experience_lower: current_exp.from

    defaults =
      from: 0
      to: 50

    set: (from, to)->
      current_exp.from = from
      current_exp.to = to
      trigger()

    getCurrent: ->
      unless current_exp.from and current_exp.to
        return defaults
      current_exp
]

app.service 'Search', [
  '$timeout'
  '$http'
  '$q'
  'Configuration'
  '$rootScope'
  (timeout, http, q, Configuration, rootScope) ->
    timer = null

    currentOptions =
      group: Configuration.getGroup()

    lastSearch = null

    searching = (bool = yes) ->
      rootScope.$broadcast 'searching', bool

    save = (options = {}) ->
      data = angular.extend currentOptions, options
      searching()
      http.post('/search.json', data).then (response) ->
        rootScope.$broadcast 'result', response.data
      , (err) ->
        console.log err
      .finally () ->
        searching no

    do: save

    trigger: (options, timeoutValue = 1000) ->
      timeout.cancel timer if timer?
      timer = timeout ->
        save options
      , timeoutValue
]
