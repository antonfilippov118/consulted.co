app = angular.module 'consulted.finder.services', []

app.service 'Configuration', [
  '$rootElement'
  (root) ->
    _group = false
    setGroup: (group) ->
      _group = group
    getGroup: -> _group
    getRates: () ->
      from: root.data 'rate-min'
      to: root.data 'rate-max'
    getExperiences: () ->
      from: root.data 'experience-min'
      to: root.data 'experience-max'
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

    getDates: -> days

    getCurrent: () ->
      return ['Next 14 days'] if fortnight
      days.sort (first, second) ->
        return -1 if first.isBefore second
        1
      .map (obj) ->
        obj.format 'ddd'

]

app.service 'Time', [
  'Search'
  Time = (Search, http, q) ->
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
      name: 'until 06:00'
      from: 0
      to: 6
    ,
      name: '06:00-09:00'
      from: 6
      to: 9
    ,
      name: '09:00-12:00'
      from: 9
      to: 12
    ,
      name: '12:00-15:00'
      from: 12
      to: 15
    ,
      name: '15:00-18:00'
      from: 15
      to: 18
    ,
      name: '18:00-21:00'
      from: 18
      to: 21
    ,
      name: 'After 21:00'
      from: 21
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
    getCurrent: ->
      times
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
  'Configuration'
  (Search, Configuration) ->
    current_rate = {}

    trigger = () ->
      Search.trigger rate_lower: current_rate.from, rate_upper: current_rate.to

    defaults = Configuration.getRates()

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
  'Configuration'
  (Search, Configuration) ->
    current_exp = {}

    trigger = () ->
      Search.trigger experience_upper: current_exp.to, experience_lower: current_exp.from

    defaults = Configuration.getExperiences()

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

app.service 'Call', [
  'Date'
  'Time'
  '$http'
  '$q'
  (Date, Time, http, q) ->
    matchTimes = (date, times) ->
      times = times.sort (a, b) -> a.from - b.from
      for time in times
        return yes if time.from <= date.hour() <= time.to
      no
    matchDate = (date, date2) ->
      date.isSame(date2, 'day') || date.isAfter(date2)

    matchDateTime = (checkDate, times, date) ->
      matchDate(date, checkDate) && matchTimes(date, times)

    findNextTime: (offer) ->
      findTime = (available_times) ->
        times = available_times.sort (a, b) -> a.start - b.start
        dates = Date.getDates()
        dateFiltered = dates.length > 0
        fTimes = Time.getCurrent()
        fTimesFiltered = fTimes.length > 0
        for date in dates
          for ts in times
            mom = moment ts.start * 1000
            if fTimesFiltered and dateFiltered
              match = matchDateTime date, fTimes, mom
            else if dateFiltered
              match = matchDate(mom, date)
            else
              match = matchTimes date, fTimes
            continue if match is no

            data =
              date: mom
              length: do ->
                if offer.maximum_length < ts.max_length
                  offer.maximum_length
                else
                  ts.max_length
            return data
        data =
          date: moment times[0].start * 1000
          length: times[0].max_length
      result = q.defer()
      http.get("/times/#{offer.expert.slug}/#{offer.slug}").then (response) ->
        result.resolve findTime response.data
      , (err) ->
        result.reject err

      result.promise


]
