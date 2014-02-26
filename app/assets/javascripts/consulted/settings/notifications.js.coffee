$ ->
  # User notifications

  $('#user_meeting_notification').on 'click', ->
    $('.notification_time').toggle $(this).attr 'checked'

  $('#user_break').on 'click', ->
    $('.break_time').toggle $(this).attr 'checked'

