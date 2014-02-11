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