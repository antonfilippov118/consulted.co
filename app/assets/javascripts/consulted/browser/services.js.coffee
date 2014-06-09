app = angular.module 'consulted.browser.services', []

app.service 'Search', [
  '$http'
  '$q'
  (http, q) ->
    do: (term) ->
      result = q.defer()

      http.post('/group/search.json', text: term).then (response) ->
        result.resolve response.data
      , (err) ->
        result.reject err

      result.promise

]

app.service 'Scroll', [
  '$window'
  '$timeout'
  ($window, $timeout) ->
    getHeight = (depth) ->
      return 690 if depth is 0
      console.log depth
      $("#height_#{depth}").offset().top


    scroll: (group, event) ->
      if $($window).width() <= 480
        {depth} = group
        try
          $timeout ->
            height = getHeight(depth)
            $('body').animate({scrollTop: height}, 500)
          , 200
        catch e
          return
]
