$ ->
  window.CONSULTED = window.CONSULTED || {}
  savebar = $('#savebar')
  trigger = (text = "Saved profile information!", opts) ->
    opts = $.extend {
      text: "<strong>#{text}</strong>"
      layout: 'bottom'
      template: '<div class="message"><span class="noty_text"></span></div>'
      timeout: 2000
    }, opts
    notification = noty opts

  window.CONSULTED.trigger = trigger

