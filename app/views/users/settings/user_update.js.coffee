<% if @result.failure? %>
CONSULTED.trigger('An error occured: <%= @result.message %>', type: 'error', timeout: 3000)
<% else %>
CONSULTED.trigger()
$('#change_expert').replaceWith('<%= render partial: "users/offers/expert_page_change"%>')
setTimeout ->
  $('.modal').modal 'hide'
, 200
<% end %>
