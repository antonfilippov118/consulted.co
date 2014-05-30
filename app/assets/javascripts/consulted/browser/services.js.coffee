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
    scroll: (group, event) ->
      if $($window).width() <= 480
        {depth} = group
        try
          height = $("#height_#{depth}").offset().top
          $timeout ->
            $('body').animate({scrollTop: height}, 500)
          , 200
        catch e
          return
]
