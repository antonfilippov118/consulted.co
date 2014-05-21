app = angular.module 'consulted.finder.filters', []

app.filter 'truncate', [
  () ->
    (input, max, disabled = no, wordwise = yes, elipsis = '...') ->
      return '' unless input
      return input if disabled

      max = parseInt max, 10

      return input unless max
      return input if input.length <= max

      input = input.substr 0, max
      if wordwise
        lastSpace = input.lastIndexOf ' '
        if lastSpace > -1
          input = input.substr 0, lastSpace

      return "#{input}#{elipsis}"

]

app.filter 'careerYear', [
  () ->
    change = (year) ->
      number = "#{year}".substr -2, 2
      "'#{number}"
    (year, yearTo = false) ->
      return change year unless angular.isNumber yearTo
      return change year if year is yearTo
      "#{change(year)}-#{change(yearTo)}"
]
