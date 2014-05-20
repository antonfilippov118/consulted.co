$('#status').text 'Your profile has been synchronized.'
setTimeout ->
  window.location.assign '<%= session[:omniauth_return] || overview_path %>'
, 500
