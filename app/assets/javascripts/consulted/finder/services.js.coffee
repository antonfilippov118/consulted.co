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

    getLanguages: () ->
      ['english', 'mandarin', 'spanish', 'arabic', 'german']

    isActive: (lang) ->
      lang in activeLanguages

    getCurrent: -> activeLanguages

    toggle: (lang) ->
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
  '$http'
  '$q'
  (Search, http, q) ->

    activeContinents = []
    country = ""
    countryActive = no

    trigger = (opts = { continents: activeContinents }) ->
      Search.trigger opts

    getContinents: () ->
      result = q.defer()
      http.get('/users/regions.json', cache: yes).then (response) ->
        result.resolve response.data
      result.promise

    getCurrent: -> activeContinents

    isActive: (continent) ->
      continent in activeContinents

    setOnly: (continent) ->
      activeContinents = [continent]
      trigger()

    setCountry: (_country) ->
      country = _country
      trigger country: country

    toggle: (continent) ->
      idx = activeContinents.indexOf continent
      if idx > -1
        activeContinents.splice idx, 1
      else
        activeContinents.push continent
      trigger()
]

app.service 'Bookmark', [
  'Search'
  (Search) ->
    bookmark = no
    toggle: () ->
      bookmark = !bookmark
      Search.trigger bookmark: bookmark
    isActive: -> bookmark

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
  (timeout, http, q, Configuration) ->
    timer = null

    currentOptions =
      group: Configuration.getGroup()

    save = (options = {}) ->
      timer = timeout () ->
        console.log 'saving...'
        console.log  angular.extend currentOptions, options
      , 2000

    trigger: (options) ->
      timeout.cancel timer unless timer is null
      save options
]
