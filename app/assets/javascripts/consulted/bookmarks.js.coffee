$ ->
  toggle = $('.show_all')


  toggle.on 'click', () ->
    el = $(this)
    list = $(el.data('target'))
    return unless list.length > 0
    if el.text() is 'show all'
      list.find('li').removeClass 'hidden'
      el.text 'show less'
    else
      list.find('li').each (idx, el) ->
        if idx > 2
          $(el).addClass 'hidden'
      el.text 'show all'


