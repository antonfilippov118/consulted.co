$ ->
  $('#synchronize_linkedin').on 'click', () ->
    CONSULTED.trigger '<i class="fa fa-spinner fa-spin"></i> Synchronizing Linkedin Profile.. Please wait.', timeout: no

  $('.toggle-shared').on 'click', () ->
    el = $(this)
    form = el.closest('form')

    # set the reverse
    hidden = $(el.data('target'))

    if hidden.val() is "true"
      hidden.val("false")
    else
      hidden.val("true")

    form.submit()

    # switch texts
    text = el.data 'text'
    old = el.text()
    el.text text
    el.data 'text', old

    # toggle the class
    $(el.attr('href')).toggleClass 'disabled'

  $('#user_email_form').validate
    rules:
      'user[contact_email]':
        required: yes
        email: yes
    errorPlacement: (label, element) ->
      el = $(element)
      el.removeClass 'chk'
      el.addClass 'crs'
    success: (label, element) ->
      el = $(element)
      el.addClass 'chk'
      el.removeClass 'crs'

  $('#unlock_user_email').click () ->
    $('#user_contact_email').removeAttr 'readonly'
    $(this).hide()
    $('#save_user_email').show()

  $('#save_user_email').click () ->
    return if $('#user_contact_email').hasClass 'error'
    $('#user_contact_email').attr 'readonly', yes
    $(this).hide()
    $('#unlock_user_email').show()







