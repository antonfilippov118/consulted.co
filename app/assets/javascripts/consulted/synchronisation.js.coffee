$ ->
  return unless $('#synchro_trigger').length > 0

  $.ajax
    url: '/synch_linkedin'
    type: 'PATCH'
    success: (data) ->
      if data.error
        $('#error_message').show()
        $('#status').hide()
        $("#error").show()
        $('#loading').hide()

  setMessage = (msg) ->
    $('#status').text msg

  timeout = (msg, time) ->

    rnd = (additional) ->
      Math.random() * (200 - 800) + 200 + additional

    setTimeout ->
      setMessage msg
    , rnd time

  timeout 'Retrieving profile information...', 1000
  timeout 'Synchronizing profile information...', 2500
  timeout 'Finishing the process...', 4000



