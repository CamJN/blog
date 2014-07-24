$(document).on('ready page:change', function() {
  $('#no-button').click(function(){$('#overlay').hide();$.cookie('no_tour',1);});
});
