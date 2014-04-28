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
    console.log  $(el.attr('href'))
    $(el.attr('href')).toggleClass 'disabled'



