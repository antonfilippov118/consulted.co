$ ->
  window.CONSULTED = window.CONSULTED || {}
  savebar = $('#savebar')
  trigger = (text = "Saved profile information!", opts) ->
    opts = $.extend {
      text: "<strong>#{text}</strong>"
      layout: 'bottom'
      template: '<div class="noty_message"><span class="noty_text"></span></div>'
      timeout: 1000
      type: 'success'
    }, opts
    setTimeout ->
      noty opts
    , 500

  window.CONSULTED.trigger = trigger

