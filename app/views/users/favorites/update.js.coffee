$('#bookmark').hide()
$('#bookmark').replaceWith('<%= render partial: "bookmark" %>')
$('#<%= dom_id(@expert) %>').fadeOut 'slow', ->
  $(this).remove()
  if $('.expert').length is 0
    $('#bookmarks').append $('<div class="text-center" id="no_bookmarks">You have no experts bookmarked</div>')
