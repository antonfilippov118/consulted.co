$ ->
  submitForm = () ->
    form = $(this).closest('form')
    form.submit()

  $('#user_country').on 'change', submitForm
  $('.meeting-setting').on 'change', submitForm
  $('.language').on 'click', submitForm

  $(".help").tooltip
    placement: 'top'
  .click () ->
    $(this).tooltip('toggle')