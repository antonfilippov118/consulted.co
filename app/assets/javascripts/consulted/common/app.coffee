app = angular.module 'consulted.common', [
  'ngSanitize'
]

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

      result.promise

    getOffers: () ->
      result = q.defer()
      http.get('/offers/list.json').then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err
      result.promise

    reload: -> rootScope.$broadcast 'offers:update'

    delayedSave: (offer) ->
      timeout.cancel timer if timer?
      timer = timeout ->
        save offer, 'Your changes were saved.', timeout: 700
      , 2500

    save: save
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

app.filter 'moment', [
  '$rootElement'
  ($rootElement) ->
    offset = $rootElement.data('offset') || '+00:00'
    (input, format = 'YYYY-MM-DD') ->
      moment.utc(input).zone(offset).format(format)
]
