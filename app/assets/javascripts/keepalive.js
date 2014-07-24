$(document).on('ready page:change', function() {
  if(($('#user a.dropdown-toggle').text().trim() !== 'Guest')&&(typeof window.keepaliveInterval === "undefined")){
    window.keepaliveInterval = setInterval(
      function(){$.getJSON(document.location.origin+"/ping");},
      1000 * 60 * (10 - 1)
    );
  }
});
