<% if @result.failure? %>
CONSULTED.trigger('An error occured: <%= @result.message %>', type: 'error')
<% else %>
CONSULTED.trigger()
$('#change_expert').replaceWith('<%= render partial: "users/offers/expert_page_change"%>')
$('.modal').modal 'hide'
<% end %>
