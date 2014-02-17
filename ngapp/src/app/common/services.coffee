app = angular.module "consulted.common.services", []

app.service 'Saving', [
  '$timeout',
  ($timeout) ->
    {body} = document

    hide: ->
      $timeout ->
        angular.element(body).removeClass 'loading'
      , 500

    show: ->
      angular.element(body).addClass 'loading'

]

app.service "Hash", () ->
  s4:() ->
    Math.floor((1 + Math.random()) * 0x10000)
      .toString(16)
      .substring(1)

