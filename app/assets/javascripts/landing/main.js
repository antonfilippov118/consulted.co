$(document).ready(function() {

  $('#nav').css({
    top: '0px',
    opacity: '1'
  });
  $('#landing-main-bottom').css({
    bottom: '0px',
    opacity: '1'
  });

  $(window).scrollTop(0);
  $(window).bind('scroll', function(e) {
    scrollbar();
  });

  $('a[href*=#]:not([href=#])').click(function() {
    if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
      if (target.length) {
        $('html,body').animate({
          scrollTop: target.offset().top
        }, 1000);
        return false;
      }
    }
  });

  $('.carousel').carousel({
    interval: 3500
  });

});

function scrollbar() {
  if ($(window).width() > 992) {
    var position = $(window).scrollTop();
    if (position > ($('#landing-main').height() - 50)) {
      $('#nav').addClass('smallbar');
      //$('#logo').addClass('black');
      $('#logo-white').addClass('hidden');
      $('#logo-black').removeClass('hidden');
    } else {
      $('#nav').removeClass('smallbar');
      //$('#logo').removeClass('black');
      $('#logo-white').removeClass('hidden');
      $('#logo-black').addClass('hidden');
    }
  }
}
