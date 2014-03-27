
if $('#fav_link i').hasClass('fa-star')
   $('#fav_link i').fadeOut('fast',
      -> $(this).addClass('fa-star-o').removeClass('fa-star')
      #.html('Bookmark')
   ).fadeIn('fast')
else
   $('#fav_link i').fadeOut('fast',
       -> $(this).addClass('fa-star').removeClass('fa-star-o')
       #.html('Unbookmark')
   ).fadeIn('fast')
