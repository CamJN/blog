if $('a.dropdown-toggle').text().trim() isnt 'Guest'
  setInterval ->
    $.get document.URL
    ,
    1000 * 60 * (10 - 1)
