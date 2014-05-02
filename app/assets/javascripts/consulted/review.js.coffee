$ ->
  times = $('.time-point')
  uncheck = (times) ->
    times.each (index, time) ->
      time = $(time)
      time.next('input[type=radio]').removeAttr 'checked'
    times.removeClass 'sel'

  check = (time) ->
    time.next('input[type=radio]').prop 'checked', yes
    times.each (idx, _time) ->
      _time = $(_time)
      _time.addClass 'sel' if _time.data('value') <= time.data('value')

  show = (time) ->
    value = time.data 'value'
    $('#howlong').text value

  times.on 'click', () ->
    time = $(this)
    uncheck times
    check time
    show time

  times.on 'mouseover', () ->
    time = $(this)
    show time

  times.on 'mouseout', () ->
    value = $('input[type=radio]:checked').val()
    $('#howlong').text value

  # select the first time on load
  $(".time-point:first").trigger 'click'

