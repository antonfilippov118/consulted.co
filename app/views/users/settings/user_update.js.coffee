<% if @result.failure? %>
CONSULTED.trigger('<%= @result.message %>', type: 'error')
<% else %>
CONSULTED.trigger('Your profile has been saved!', type: 'success')
<% end %>
