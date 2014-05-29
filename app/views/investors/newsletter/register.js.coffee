$('#error').fadeOut('slow', () ->
  $('#success').fadeIn()
  $('#newsletter_email').val ''
)
