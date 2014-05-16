app = angular.module 'consulted.scheduler', []

app.constant 'SMALLEST_TIME', 5
app.constant 'TEMPLATE_PATH', (name) -> name

app.directive 'calendar', [
  'TEMPLATE_PATH'
  (templatePath) ->
    replace: yes
    templateUrl: templatePath 'calendar'
    link: (scope, element, attrs) ->
      console.log "calendar directive"
]

app.directive 'calendarBack', [
  'TEMPLATE_PATH'
  (templatePath) ->
    replace: yes
    templateUrl: templatePath 'calendar_back'
    link: (scope, element, attrs) ->
      console.log "calendarBack directive"
]

app.factory 'positionToMinutes', [
  '$filter'
  (filter) ->
    minutesPerDay = 24 * 60
    nearestTime = filter 'nearestTime'
    minutes: (element) ->
      totalHeight = element.height()
      (position) ->
        nearestTime(position / totalHeight * minutesPerDay)

]

app.filter 'nearestTime', [
  'SMALLEST_TIME'
  (smallestTime) ->
    round = Math.round
    (number) ->
      smallestTime * round number / smallestTime
]

app.filter 'zeroFix', () ->
  (number) ->
    if number >= 10
      "#{number}"
    else
      "0#{number}"


app.filter 'minutesToTime', [
  '$filter'
  (filter) ->
    zeroFix = filter 'zeroFix'
    floor = Math.floor
    (minutes) ->
      hour = floor minutes / 60
      minute = minutes % 60
      "#{zeroFix(hour)}:#{zeroFix(minute)}"
]


app.factory 'clickPosition', () ->
  position: (element) ->
    parent = element.parent()
    # move next line if height is dynamic
    offset = parent.offset()
    (event) ->
      x: event.pageX - offset.left
      y: event.pageY - offset.top

app.directive 'calendarFront', [
  'clickPosition'
  'positionToMinutes'
  'TEMPLATE_PATH'
  (clickPosition, positionToMinutes, templatePath) ->
    replace: yes
    scope: yes
    templateUrl: templatePath 'calendar_front'
    link: (scope, element, attrs) ->
      parent = element.parent()
      position = clickPosition.position element
      minutes =  positionToMinutes.minutes element

      {max, min, abs} = Math

      scope.elements = []

      addElement = (range) ->
        console.log "addElement"
        for existing in scope.elements
          # full overlap
          if range.from <= existing.from and range.to >= existing.to
            range.to = existing.from
            range.bottom = existing.top

          # partial overlap on top
          if existing.from < range.from < existing.to
            range.from = existing.to
            range.top = existing.bottom

          # partial overlap on bottom
          if existing.from < range.to < existing.to
            range.to = existing.from
            range.bottom = existing.top

        scope.elements.push range

      scope.$on "change", (event, index, range, cb) ->

        console.log "change", index, range
        for existing, i in scope.elements when i isnt index
          console.log "checking against element", i
          # full overlap
          if range.from <= existing.from and range.to >= existing.to
            range.to = existing.from
            range.bottom = existing.top
            console.log "full overlap"

          # partial overlap on top
          if existing.from < range.from < existing.to
            range.from = existing.to
            range.top = existing.bottom
            console.log "overlap top"

          # partial overlap on bottom
          if existing.from < range.to < existing.to
            range.to = existing.from
            range.bottom = existing.top
            console.log "overlap bottom"
        cb
          to: range.to
          from: range.from
          top: range.top
          bottom: range.bottom

      scope.$on "remove", (event, index) ->
        scope.elements.splice index, 1

      #scope.remove = (event, index) ->
      # console.log "remove event", index

      #determing how large the element to create should be
      element.on 'mousedown', (event) ->
        # do not handle event that did not happen directly on this DOM element
        if not element.is event.target
          event.stopPropagation()
          return

        downPosition = position event
        scope.$broadcast "adding-start"

        disableEvents = () ->
          element.off eventName for eventName in ['mouseup', 'mouseleave', 'mousemove']
          element.removeClass className for className in ['adding-up', 'adding-down']
          scope.$broadcast "adding-end"

        element.on 'mousemove', (event) ->
          currentPosition = position event
          directionDown = currentPosition.y - downPosition.y > 0
          element.toggleClass 'adding-down', directionDown
          element.toggleClass 'adding-up', not directionDown
          top = min currentPosition.y, downPosition.y
          bottom = max currentPosition.y, downPosition.y
          scope.$broadcast 'adding',
            top: top
            bottom: bottom
            from: minutes top
            to: minutes bottom


        element.on 'mouseup', (event) ->
          currentPosition = position event
          console.log "creave event for", abs currentPosition.y - downPosition.y
          top = min currentPosition.y, downPosition.y
          bottom = max currentPosition.y, downPosition.y
          scope.$apply () ->
            addElement
              top: top
              bottom: bottom
              from: minutes top
              to: minutes bottom
          disableEvents()

        element.on 'mouseleave', (event) ->
          console.log "no event"
          disableEvents()
]

app.directive 'element', [
  'clickPosition'
  'positionToMinutes'
  'TEMPLATE_PATH'
  (clickPosition, positionToMinutes, templatePath) ->
    replace: yes
    scope:
      data: '=data'
      index: '=index'
    templateUrl: templatePath 'element'
    link: (scope, element, attrs) ->

      scope.$watch 'data', (newData) ->
        console.log "data changed", newData

      position = clickPosition.position element.parent()
      minutes =  positionToMinutes.minutes element.parent()
      element.css
        top: "#{scope.data.top}px"
        height: "#{scope.data.bottom - scope.data.top}px"
      scope.remove = (event, index) ->
        event.stopPropagation()
        scope.$emit "remove", scope.index

      $('.resizer', element).on 'mousedown', (event) ->
        #return unless element.is event.target
        console.log "start resize"

        parent = element.parent()

        directionDown = $(event.target).hasClass 'resizer-bottom'
        parent.addClass 'adding-down' if directionDown
        parent.addClass 'adding-up' if not directionDown

        disableEvents = () ->
          parent.off eventName for eventName in ['mouseup', 'mousemove', 'mouseleave']
          parent.removeClass className for className in ['adding-up', 'adding-down']
          scope.$emit "change", scope.index, scope.data, (range) ->
            scope.data.top = range.top
            scope.data.bottom = range.bottom
            scope.data.from = range.from
            scope.data.to = range.to
            element.css
              top: "#{scope.data.top}px"
              height: "#{scope.data.bottom - scope.data.top}px"
            scope.$apply () ->
              scope.data.from = minutes scope.data.top
              scope.data.to = minutes scope.data.bottom


        parent.on 'mousemove', (event) ->
          currentPosition = position event
          #console.log currentPosition
          if directionDown
            scope.data.bottom = currentPosition.y
          else
            scope.data.top = currentPosition.y
          element.css
            top: "#{scope.data.top}px"
            height: "#{scope.data.bottom - scope.data.top}px"

          scope.$apply () ->
            scope.data.from = minutes scope.data.top
            scope.data.to = minutes scope.data.bottom

        parent.on 'mouseup', (event) ->
          console.log "done with resize"
          disableEvents()

        #parent.on 'mouseleave', (event) ->
        # disableEvents()

]

app.directive 'elementAdding', [
  'TEMPLATE_PATH'
  (templatePath) ->
    replace: yes
    templateUrl: templatePath 'element_adding'
    link: (scope, element, attrs) ->
      scope.visible = no

      prev = null

      scope.$on "adding-start", () ->
        prev = null
        scope.$apply () ->
          scope.visible = yes

      scope.$on "adding-end", () ->
        prev = null
        scope.$apply () ->
          scope.visible = no

      scope.$on "adding", (event, data) ->
        element.css
          top: "#{data.top}px"
          height: "#{data.bottom - data.top}px"

        if not prev? or (data.from isnt prev[0] or data.to isnt prev[1])
          scope.$apply () ->
            scope.from = data.from
            scope.to = data.to
            prev = [data.from, data.to]
]
