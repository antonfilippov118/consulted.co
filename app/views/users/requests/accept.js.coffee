$('#<%= dom_id(@request) %>').fadeOut 'slow', () ->
  $(this).remove()
  updateCalls()
  checkEmpty()

updateCalls = () ->
  list = $('<%= render partial: "users/dashboard/calls", locals: { calls: @calls, upcoming: @upcoming } %>')
  console.log $('#active_calls')
  $('#active_calls').replaceWith list

checkEmpty = () ->
  list = $('#requested_calls')

  if list.children('li').length is 0
    list.append $('<li class="none">You have requested no calls</li>')



