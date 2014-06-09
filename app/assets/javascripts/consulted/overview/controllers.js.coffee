app = angular.module 'consulted.overview.controllers', [
  'consulted.overview.services'
  'consulted.overview.filters'
  'consulted.finder.filters'
]

app.controller 'TableCtrl', [
  '$scope'
  'Call'
  '$interval'
  '$filter'
  TableCtrl = (scope, Call, interval, filter) ->
    scope.loading = yes


    fetch = () ->
      Call.getCalls().then (calls) ->
        scope.review_calls = calls.reviewable
        scope.new_calls    = filter('younger')(calls.calls, 7)
        scope.future_calls = filter('older')(calls.calls, 7)
      .finally () ->
        scope.loading = no

    interval fetch, 30000

    scope.$on 'reload:calls', fetch

    fetch()
]

app.controller 'CancelCtrl', [
  'Call'
  'call'
  '$scope'
  '$modalInstance'
  CancelCtrl = (Call, call, scope, modalInstance) ->
    scope.call = call

    scope.verb = ->
      return 'Cancel' if call.active
      return 'Abandon' if call.seeker
      return 'Decline' if call.expert
      'Cancel'

    scope.dismiss = () ->
      modalInstance.dismiss()

    scope.cancel = () ->
      Call.cancel(call).then (result) ->
        CONSULTED.trigger 'Call cancelled'
        modalInstance.close()
      , (err) ->
        CONSULTED.trigger err, type: 'error'
]

app.controller 'ConfirmCtrl', [
  'Call'
  'call'
  '$scope'
  '$modalInstance'
  ConfirmCtrl = (Call, call, scope, modalInstance) ->
    scope.call = call
    scope.decline = () ->
      Call.cancel(call).then (result) ->
        CONSULTED.trigger 'Call declined'
        modalInstance.close()
      , (err) ->
        modalInstance.dismiss()

    scope.dismiss = ->
      modalInstance.dismiss()

    scope.confirm = ->
      Call.confirm(call).then (result) ->
        CONSULTED.trigger 'Call confirmed'
        modalInstance.close()
      , (err) ->
        CONSULTED.trigger err, type: 'error'


]

app.controller 'ReviewCtrl', [
  'Call'
  'call'
  '$scope'
  '$modalInstance'
  ReviewCtrl = (Call, call, scope, modalInstance) ->
    scope.call = call
    scope.validations = []
    scope.ratings = [
      { text: 'Understood my problem', name: 'understood_problem' },
      { text: 'Helped me solve my problem', name: 'helped_solve_problem' },
      { text: 'Is knowledgeable in '+call.name, name: 'knowledgeable' },
      { text: 'Provided good value for money', name: 'value_for_money' },
      { text: 'I would recommend the expert to a friend', name: 'would_recommend' },
    ]

    if call.review?
      scope.review = angular.copy(call.review)
      scope.isReadonly = true
    else
      scope.review = { }
      scope.isReadonly = false


    scope.hoveringOver = (value, name = '') ->
      scope.validations[name] = null

    scope.toggleAwesome = () ->
      return false if scope.isReadonly
      scope.review.awesome = !scope.review.awesome

    scope.dismiss = () ->
      modalInstance.dismiss()

    scope.validate_rating = (name) ->
      valid = scope.review[name]?
      scope.validations[name] = valid

    scope.validate = () ->
      scope.validate_rating rating.name for rating in scope.ratings
      scope.validate_rating 'would_recommend_consulted'
      for name, valid of scope.validations
        return false unless valid
      return true

    scope.submitReview = () ->
      return unless scope.validate()
      scope.review.feedback = null unless scope.review.hasfeedback
      Call.review(call, { "review": scope.review} ).then (result) ->
        CONSULTED.trigger 'Thank you for review!'
        modalInstance.close()
      , (err) ->
        CONSULTED.trigger err, type: 'error'
]
