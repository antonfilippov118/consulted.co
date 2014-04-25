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
  (Search) ->

    activeContinents = []
    country = ""
    countryActive = no

    trigger = (opts = { continents: activeContinents }) ->
      Search.trigger opts

    getContinents: () ->
      [
        'North America'
        'South America'
        'Western Europe'
        'Eastern Europe'
        'East Asia'
        'South Asia'
      ]

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
