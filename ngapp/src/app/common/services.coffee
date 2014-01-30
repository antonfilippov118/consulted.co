app = angular.module "consulted.common.services", []

app.service 'Saving', [
  () ->
    {body} = document

    hide: ->
      angular.element(body).removeClass 'loading'

    show: ->
      angular.element(body).addClass 'loading'

]