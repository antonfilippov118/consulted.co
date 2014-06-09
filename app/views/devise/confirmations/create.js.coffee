<% if @success %>
CONSULTED.trigger 'Confirmation email sent!'
<% else %>
CONSULTED.trigger 'There was an error sending the confirmation.'
<% end %>
