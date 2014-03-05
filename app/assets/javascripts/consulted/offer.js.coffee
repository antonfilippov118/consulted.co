$ ->
  select = $('#user_country').on 'change', () ->
    form = $(this).closest('form')
    form.submit()

