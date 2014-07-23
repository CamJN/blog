$( document ).ready(function() {
  if($('a.dropdown-toggle').text().trim() !== 'Guest'){
    setInterval(
      function(){$.getJSON(document.location.origin+"/ping");},
      1000 * 60 * (10 - 1)
    );
  }
});
