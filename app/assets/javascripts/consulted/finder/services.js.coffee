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
    activeLanguages = ['english']

    getLanguages: () ->
      ['english', 'mandarin', 'spanish', 'arabic', 'german']

    isActive: (lang) ->
      lang in activeLanguages

    toggle: (lang) ->
      idx = activeLanguages.indexOf lang
      if idx > -1
        activeLanguages.splice idx, 1
      else
        activeLanguages.push lang
      Search.trigger languages: activeLanguages

]

app.service 'Tags', [
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
      , 2500

    trigger: (options) ->
      timeout.cancel timer unless timer is null
      save options
]
