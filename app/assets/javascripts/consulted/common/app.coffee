app = angular.module 'consulted.common', []

app.service 'GroupData', [
  '$http'
  '$q'
  GroupData = (http, q) ->
    getData = () ->
      result = q.defer()
      http.get('/groups.json', cache: yes).then (response) ->
        result.resolve response.data
      result.promise

    isLastCategory = (group) ->
      return no unless group
      for child in group.children
        if child.children.length > 0
          return no
      yes

    getGroups: () ->
      result = q.defer()
      getData().then (groups) ->
        result.resolve groups
      , (err) ->
        result.reject err
      result.promise

    getRoots: () ->
      result =  q.defer()
      getData().then (groups) ->
        roots = []
        roots.push group for group in groups
        result.resolve roots
      result.promise

    findGroup: (slug) ->
      result = q.defer()
      find = (data, slug) ->
        for group in data
          if group.slug is slug
            return group
          found = find group.children, slug
          return found if found
      getData().then (groups) ->
        result.resolve find groups, slug
      result.promise

    findParent: (node) ->
      result =  q.defer()
      {slug} = node
      find = (groups, slug) ->
        for group in groups
          slugs = group.children.map (obj) -> obj.slug
          return group if slug in slugs
          group = find group.children, slug
          return group if group
      getData().then (groups) ->
        result.resolve find groups, slug
      result.promise

    showGroup: (slug) ->
      result = q.defer()
      http.get("/groups/#{slug}.json", cache: yes).then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise

    findBreadCrumb: (slug) ->
      deferredCrumbs = q.defer()
      slice = (o, properties...) ->
        ret = {}
        ret[p] = o[p] for p in properties
        ret

      find = (a, slug) ->
        for o in a
          if(o.slug is slug)
              return [ slice(o, 'name', 'slug', 'children', 'depth') ]
          if(sub = find(o.children, slug))
              return [ slice(o, 'name', 'slug', 'children', 'depth') ].concat(sub)
        return

      getData().then (groups) ->
        crumbs = find groups, slug
        deferredCrumbs.resolve crumbs
      deferredCrumbs.promise

    isLastCategory: isLastCategory

    isSecondToLastCategory: (group) ->
      for child in group.children
        return no unless isLastCategory(group)
      yes

]

app.service 'OfferData', [
  '$http'
  '$q'
  '$timeout'
  '$rootScope'
  OfferData = (http, q, timeout, rootScope) ->
    timer = null
    save = (offer, saveTxt) ->
      result = q.defer()
      http.put('/offers.json', offer).then (response) ->
        result.resolve response.data
        if saveTxt
          CONSULTED.trigger saveTxt
      , (err) ->
        result.reject err
        CONSULTED.trigger('There was an error saving your selection!', type: 'error')
      .finally () ->
        rootScope.$broadcast 'offers:update'

      result.promise

    getOffers: () ->
      result = q.defer()
      http.get('/offers/list.json').then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise


    delayedSave: (offer) ->
      timeout.cancel timer if timer?
      timer = timeout ->
        save offer, 'Your changes were saved.'
      , 3000

    save: save
]

app.service 'UserData', [
  '$http'
  '$q'
  UserData = (http, q) ->
    zone    = {}
    zones   = {}
    _offset = {}

    getSettings: () ->
      result  = q.defer()
      zone    = q.defer()
      zones   = q.defer()
      _offset = q.defer()
      http.get('/settings.json').then (response) ->
        {zones_available, timezone, offset} = response.data
        zones.resolve zones_available
        zone.resolve timezone
        _offset.resolve offset
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise

    getAvailableZones: () ->
      zones.promise

    getTimezone: () ->
      zone.promise

    getOffset: () ->
      _offset.promise

    save: (user) ->
      result = q.defer()
      http.put('/settings/timezone.json', user).then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise
]

app.service "AvailabilityData", [
  '$http'
  '$q'
  '$timeout'
  'Saving'
  AvailabilityData = (http, q, $timeout, Saving) ->
    timer = null

    save: (_event) ->
      result = q.defer()
      $timeout.cancel timer if timer?
      $timeout ->
        Saving.show()
        event = angular.copy _event

        if moment.isMoment(event.starts)
          event.starts = event.starts.format()
        if moment.isMoment(event.ends)
          event.ends = event.ends.format()

        http.put('/availabilities', availability: event).then (response) ->
          result.resolve response.data
        , (err) ->
          result.reject err
        .finally () ->
          Saving.hide()
      , 500

      result.promise

    remove: (id) ->
      result = q.defer()
      Saving.show()
      http.delete("/availabilities", params: { id: id }).then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      .finally ->
        Saving.hide()

    getEventsForWeek: (options) ->
      result = q.defer()
      http.get('/availabilities.json', params: options).then (response) ->
        _data = []
        for day, i in response.data
          events = []
          for event, index in day
            event.ends      = moment(event.ends)
            event.starts    = moment(event.starts)
            event.new_event = no
            events.push event
          _data.push events
        result.resolve _data
      , (err) ->
        result.reject err
      result.promise
]

app.service 'Saving', [
  '$rootScope'
  '$timeout'
  ($rootScope, $timeout) ->
    toggle = (type = "show") ->
      $rootScope.$broadcast "saving:#{type}"
    show: () ->
      toggle()
    hide: () ->
      $timeout ->
        toggle 'hide'
      , 500
]

app.directive 'saving', [
  '$rootScope'
  ($rootScope) ->
    replace: yes
    template: "<div ng-show=\"shown\"><i class=\"fa fa-spinner fa-spin\"></i> Saving...</div>"
    scope: yes
    link: (scope) ->
      scope.shown = no
      $rootScope.$on "saving:show", () ->
        scope.shown = yes
      $rootScope.$on "saving:hide", () ->
        scope.shown = no

]

timeFilters = {
  'minute': "mm"
  'hour': "HH:mm"
  'date': "YYYY-MM-DD"
  'datetime': "YYYY-MM-DD HH:mm:ss"
  'datehour': "YYYY-MM-DD HH:mm"
}

angular.forEach timeFilters, (format, key) ->
  app.filter key, ->
    (input) ->
      if moment.isMoment(input)
        return input.format format
      moment(input).format format

app.filter "week", [() ->
  (input, iso = yes) ->
    input = moment(input) unless moment.isMoment input
    return input.isoWeek() if iso
    return input.week()
]

app.filter "capitalize", () ->
  (input) -> "#{input.charAt(0).toUpperCase()}#{input.slice(1)}"

app.filter 'order', () ->
  (input) -> input.sort()




