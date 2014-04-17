$ ->
  $('#login_simple').modal(backdrop: 'static')
  $('#login_simple').on 'hidden.bs.modal', () ->
    window.history.back()

