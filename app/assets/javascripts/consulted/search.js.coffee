$ ->
  $('input.slider').each () ->
    el = $(this)
    min = el.data('min') || 0
    max = el.data('max') || 60
    label = el.data('label') || ' USD'
    if el.data "range"
      value = [min, max]
    else
      value = min
    el.slider
      min: min
      max: max
      step: 10
      value: value
      formater: (a) ->
        return 'All' if a is min
        "#{a}#{label}"

  $('.opener').on 'click', () ->
    span = $(this)
    li   = span.parent().siblings('li').not '.all'
    li.toggleClass 'hidden'
    text = span.data 'text'
    oldText = span.text()
    span.text text
    span.data 'text', oldText



