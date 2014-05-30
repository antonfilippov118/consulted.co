$ ->
  submitForm = (el) ->
    form = el.closest('form')
    form.submit()
  $('.meeting-setting').on 'change', ->
    submitForm $(this)
  $('.language').on 'click', () ->
    el = $(this)
    id = el.data 'target'
    checkbox = $(id)
    if checkbox.is ':checked'
      $(id).removeAttr 'checked'
    else
      checkbox.attr 'checked', yes
    el.toggleClass 'active'
    submitForm el
  $('#meetings_per_day').ionRangeSlider
    onFinish: (obj) ->
      submitForm obj.input


  $(".help").tooltip
    placement: 'top'
  .click () ->
    $(this).tooltip('toggle')
