if($('a.dropdown-toggle').text().trim() !== 'Guest'){
  setInterval(
    function(){$.get(document.URL);},
    1000 * 60 * (10 - 1)
  );
}
