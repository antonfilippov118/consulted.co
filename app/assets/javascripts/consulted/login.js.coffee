$ ->
  # toggle between social media and signup via email
  $('.toggle_login').on 'click', (event) ->
    $('#sign_up_social, #sign_up_email').hide()
    if activeView is 'sign_up_social'
      activeView = 'sign_up_email'
    else
      activeView = 'sign_up_social'
    $("##{activeView}").show()

  # login field
  login = $('#login_field')
  open = () ->
    fields = $('#password_fields')
    fields.slideDown() if login.val().length > 0
    fields.slideUp() if login.val().length is 0

  login.on 'change', open

  open()






