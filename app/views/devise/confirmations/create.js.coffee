<% if @success %>
CONSULTED.trigger 'Another confirmation email has been sent.'
<% else %>
CONSULTED.trigger 'There was an error sending the confirmation.'
<% end %>
