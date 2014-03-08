$ ->
  settings = $('.settings-link')

  settings.popover
    content: $('.settings-menu').html()
    html: yes
    title: 'Settings'
    placement: 'bottom'
