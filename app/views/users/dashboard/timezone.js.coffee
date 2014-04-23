$('#tz_modal').modal('hide')
$('#user_timezone').replaceWith('<%= render partial: "timezone" %>')
CONSULTED.trigger()
