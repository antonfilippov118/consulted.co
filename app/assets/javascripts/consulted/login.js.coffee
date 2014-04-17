$ ->
  $('#login_simple').modal(backdrop: 'static')
  $('#login_simple').on 'hidden.bs.modal', () ->
    window.history.back()

  # toggle the view for signup
  activeView = 'sign_up_social'

  $('.toggle_login').on 'click', (event) ->
    $('#sign_up_social, #sign_up_email').hide()
    if activeView is 'sign_up_social'
      activeView = 'sign_up_email'
    else
      activeView = 'sign_up_social'
    console.log activeView
    $("##{activeView}").show()



