$('#status').text 'Your profile has been synchronized.'
setTimeout ->
  window.location.href = '<%= session[:omniauth_return] || overview_path %>'
, 500
