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

  calc = (time) ->
    value = time.data 'value'
    ts = moment($('#call_from').data('timestamp') * 1000)
    if ts.isValid()
      $('#call_from').html ts.format('dddd, MMMM D YYYY h:mma')
      ts.add value, 'minutes'
      $('#call_to').html ts.format('h:mma')

  times.on 'click', () ->
    time = $(this)
    uncheck times
    check time
    calc time
    show time

  times.on 'mouseover', () ->
    time = $(this)
    show time

  times.on 'mouseout', () ->
    value = $('input[type=radio]:checked').val()
    $('#howlong').text value

  # select the first time on load
  $(".time-point:first").trigger 'click'

