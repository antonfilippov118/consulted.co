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
    offer = null
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
      fetch(null, offer) if offer?

    transform = (_, events) ->
      monday = scope.currentWeek.clone().isoWeekday(1).hour(0).minute(0).second(0).millisecond(0)
      sunday = scope.currentWeek.clone().isoWeekday(7).hour(23).minute(59).second(59).millisecond(0)
      TimezoneData.getFormattedOffset().then (offset) ->
        scope.events = for i in [0..6]
          []
        for event in events
          start = moment.unix(event.start).zone(offset)
          end  = moment.unix(event.end).zone(offset)
          if (start.isAfter(monday) and end.isBefore(sunday))
            day = start.isoWeekday()
            _start = Math.abs start.clone().hour(0).minute(0).diff(start, 'minutes')
            _end =   Math.abs end.clone().hour(0).minute(0).diff(end, 'minutes')
            scope.events[day - 1].push time: [_start, _end], data: { start: start }

    fetch = (_, _offer) ->

      offer = _offer
      ExpertAvailabilities.get(offer).then (events) ->
        scope.$broadcast 'data:ready', events
      .finally -> scope.show_cal = yes

    scope.$on 'offer:change', fetch
    scope.$on 'data:ready', transform
    scope.$on 'goto:offer', (_, event) ->
      {data} = event
      TimezoneData.getFormattedOffset().then (offset) ->
        {data} = event
        sessionStorage.setItem "#{slug}:time", data.start?.format('YYYY-MM-DD HH:mm Z')
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

