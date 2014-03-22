$ ->
  select = $('#request_start')
  span   = $('#end_time')
  return unless span.length > 0

  calc = () ->
    time   = moment select.val()
    offset = moment().zone select.val()
    length = $('[name="request[length]"]:checked').val()
    span.html time.add('m', length).zone(offset.zone()).format('YYYY-MM-DD HH:mm')

  select.on 'change', calc
  $('[name="request[length]"]').on 'click', calc
  calc()
