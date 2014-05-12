$ ->
  $('#new_user').validate
    errorPlacement: (label, element) ->
      el = $(element)
      crossed = el.siblings('span.crossed')
      checked = el.siblings('span.checked')
      crossed.show()
      checked.hide()
    success: (label, element) ->
      el = $(element)
      crossed = el.siblings('span.crossed')
      checked = el.siblings('span.checked')
      crossed.hide()
      checked.show()

    rules:
      'user[email]':
        required: yes
        email: yes
        remote:
          url: '/users/available'
      'user[name]':
        required: yes
        minlength: 6
      'user[password]':
        required: yes
        minlength: 6
      'user[password_confirmation]':
        required: yes
        equalTo: '#user_password'
    messages:
      email:
        remote: jQuery.validator.format("{0} is already taken.")

  # toggle between social media and signup via email
  activeView = localStorage.getItem('last_active_view') || 'sign_up_social'

  $('.toggle_login').on 'click', -> toggle yes

  toggle = (remember = no) ->
    $('#sign_up_social, #sign_up_email').hide()
    if activeView is 'sign_up_social'
      activeView = 'sign_up_email'
    else
      activeView = 'sign_up_social'
    localStorage.setItem( 'last_active_view', activeView) if remember
    $("##{activeView}").show()

  $("##{activeView}").show()


