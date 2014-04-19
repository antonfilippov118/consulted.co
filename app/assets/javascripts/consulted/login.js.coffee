$ ->

  $('.toggle_login').on 'click', (event) ->
    $('#sign_up_social, #sign_up_email').hide()
    if activeView is 'sign_up_social'
      activeView = 'sign_up_email'
    else
      activeView = 'sign_up_social'
    console.log activeView
    $("##{activeView}").show()



