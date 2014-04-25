$.noty.closeAll()
<% if @result.failure? %>
$('#linkedin_modal').hide()
CONSULTED.trigger('<%= @result.message %>', type: 'error')
<% else %>
CONSULTED.trigger('Synchronized, reloading page...')
setTimeout ->
  window.location.reload()
, 1000
<% end %>