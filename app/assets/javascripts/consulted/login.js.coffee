$ ->
  # toggle between social media and signup via email
  activeView = 'sign_up_social'
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
    fields.slideDown() if login.val()
    fields.slideUp() if !login.val()

  login.on 'change', open

  open()






