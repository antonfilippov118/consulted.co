$ ->
  $('#synchronize_linkedin').on 'click', () ->
    CONSULTED.trigger '<i class="fa fa-spinner fa-spin"></i> Synchronizing Linkedin Profile.. Please wait.', timeout: no

