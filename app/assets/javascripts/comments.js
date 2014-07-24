// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('ready page:change', function() {
  if($('div.panel-success').length > 0){
    setTimeout(
      function(){$('div.panel-success').removeClass('panel-success').addClass('panel-default');},
      1000 * 5
    );
  }
});
