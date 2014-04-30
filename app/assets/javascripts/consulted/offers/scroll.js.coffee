$ ->
  if $('#offerbar').length > 0
    if $(window).width() < 768
      $('#offerbar').css('top', $('.offerfull').offset().top - 26)
    else
      $('#offerbar').css('top', $('.offerfull').offset().top - 40)

    scrollbar = () ->
      position = $(window).scrollTop();
      $('#offerbar').toggleClass 'stick', (position > $('.offerfull').offset().top - 26)

    $(window).scrollTop(0)
    $(window).bind 'scroll', () -> scrollbar()

    $("a[href*=#]:not([href=#])").click ->
      $('#offerbar').find('li').removeClass 'active'
      parent = $(this).parent()
      parent.addClass 'active' unless parent.hasClass 'active'
      if location.pathname.replace(/^\//, "") is @pathname.replace(/^\//, "") and location.hostname is @hostname
        target = $(@hash)
        target = (if target.length then target else $("[name=" + @hash.slice(1) + "]"))
        if target.length
          $("html,body").animate
            scrollTop: target.offset().top
          , 1000
          false

