$ ->
  submitForm = () ->
    form = $(this).closest('form')
    form.submit()

  $('#user_country').on 'change', submitForm
  $('.language').on 'click', submitForm



