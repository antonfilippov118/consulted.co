app = angular.module 'consulted.offer_select.controllers', [
  'consulted.offer_select.services'
  'consulted.scheduler'
]


app.controller 'AvailabilityCtrl', [
  '$scope'
  'ExpertAvailabilities'
  'TimezoneData'
  '$window'
  'ExpertOffers'
  'Configuration'
  (scope, ExpertAvailabilities, TimezoneData, $window, ExpertOffers, Configuration) ->
    slug = Configuration.getSlug()
    scope.next = (event) ->
      scope.currentWeek = scope.currentWeek.clone().add('d', 7)

    scope.prev = (event) ->
      scope.currentWeek = scope.currentWeek.clone().subtract('d', 7) unless scope.firstWeek

    scope.currentWeek = moment()
    scope.firstWeek = no

    scope.$watch 'currentWeek', () ->
      scope.firstWeek = moment().isoWeekday(1).isAfter(scope.currentWeek.clone().subtract('d',7))
      scope.from = scope.currentWeek.clone().isoWeekday(1).format('dddd, DD MMMM YYYY')
      scope.to = scope.currentWeek.clone().isoWeekday(7).format('dddd, DD MMMM YYYY')

    transform = (_, events) ->
      TimezoneData.getFormattedOffset().then (offset) ->
        scope.events = for i in [0..6]
          []
        for event in events
          start = moment.unix(event.start).zone(offset)
          end  = moment.unix(event.end).zone(offset)
          day = start.day()
          _start = Math.abs start.clone().hour(0).minute(0).diff(start, 'minutes')
          _end =   Math.abs end.clone().hour(0).minute(0).diff(end, 'minutes')
          scope.events[day].push time: [_start, _end], data: { start: start }

    fetch = (_, offer) ->
      ExpertAvailabilities.get(offer).then (events) ->
        scope.$broadcast 'data:ready', events
      .finally -> scope.show_cal = yes

    scope.$on 'offer:change', fetch
    scope.$on 'data:ready', transform
    scope.$on 'goto:offer', (_, event) ->
      {data} = event
      TimezoneData.getFormattedOffset().then (offset) ->
        {data} = event
        localStorage.setItem "#{slug}:time", data.start?.format('YYYY-MM-DD HH:mm Z')
        offer = ExpertOffers.getSelected()
        $window.location.assign "/offers/#{offer.slug}-with-#{slug}/review"

]

app.controller 'OffersCtrl', [
  '$scope'
  'ExpertOffers'
  OffersCtrl = (scope, ExpertOffers) ->
    selected = null

    fetch = () ->
      scope.loading = yes
      ExpertOffers.get().then (data) ->
        scope.offers = data
      .finally () ->
        scope.loading = no

    fetch()
]

