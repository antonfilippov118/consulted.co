$('.spinner').fadeOut 'slow', () ->
  $('#result').removeClass('hidden').html '<%= 42 %>'