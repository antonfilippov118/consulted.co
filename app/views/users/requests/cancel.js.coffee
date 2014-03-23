$("#request_<%= @request.id %>").fadeOut 'slow', () ->
  $(this).remove()
  checkEmpty()

checkEmpty = () ->
  list = $('#active_requests')

  if list.children('li').length is 0
    list.append $('<li>You have requested no calls</li>')
