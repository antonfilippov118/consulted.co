<% if @result.failure? %>
CONSULTED.trigger('An error occured: <%= @result.message %>', type: 'error')
<% else %>
CONSULTED.trigger()
<% end %>
