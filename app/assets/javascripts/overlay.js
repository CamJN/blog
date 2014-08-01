$(document).on('ready page:change', function() {
  if($('#overlay.phone').length > 0){
    function resizefcn(){
      $('#overlay.phone .col-'+(($(window).width() > $(window).height())?'sm':'xs')+'-6').toggleClass('col-sm-6').toggleClass('col-xs-6');
    }
    resizefcn();
    $(window).resize(resizefcn);
  }
  $('#no-button').click(function(){$('#overlay').hide();$.cookie('no_tour',1);});
});
