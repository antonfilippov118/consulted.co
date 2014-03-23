$('#<%= dom_id(@request) %>').fadeOut 'slow', () ->
  updateCallsWith $(this)

updateCallsWith = (el) ->
  list = $('<%= render partial: "calls", locals: { calls: @calls } %>')


