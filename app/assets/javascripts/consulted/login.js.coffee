$ ->
  # login field
  login = $('#login_field')
  fields = $('#password_fields')
  open = () ->
    fields.slideDown()

  login.on 'focus', open

  open() if !!login.val()





