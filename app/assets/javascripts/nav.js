$(document).on('ready page:change', function() {
  $('#tour a').click(function(){
    $.removeCookie('no_tour');
    return false;
  });
});
