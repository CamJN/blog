// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on('ready page:change', function() {
  var newComments = $('div.panel-success')
  if(newComments.length > 0){
    setTimeout(
      function(){
        newComments.removeClass('panel-success').addClass('panel-default');
      },
      1000 * 5
    );
  }
});
