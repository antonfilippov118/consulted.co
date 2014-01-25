app = angular.module "consulted.static.controllers", [
  'consulted.static.services'
  'consulted.users.services'
]

app.controller "LegalController", [
  "$scope"
  (scope) ->
    console.log "Legal"
]

app.controller "FaqController", [
  "$scope"
  (scope) ->
    console.log "FAQ"
]

app.controller "CareerController", [
  "$scope"
  (scope) ->
    console.log "Career"
]

app.controller "UseCasesController", [
  "$scope"
  (scope) ->
    console.log "Use cases"
]

app.controller "SitemapController", [
  "$scope"
  (scope) ->
    console.log "Sitemap"
]

app.controller "ContactController", [
  "$scope"
  "Contact"
  "User"
  (scope, contact) ->
    scope.error   = no
    scope.message = {}

    scope.contact = () ->
      return if scope.sending is yes
      scope.sending = yes

      contact.submit(scope.message).then (status) ->
        scope.status = status
      , (err) ->
        scope.error = "There was an error sending the contact form."
      .finally () ->
        scope.sending = no
]