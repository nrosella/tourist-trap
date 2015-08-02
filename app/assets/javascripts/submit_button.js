$(function(){
  $('#borough-select').change(function(event){
      var borough = $(this).val();
      $('#manhattan_form').hide();
      $('.submit').addClass("disabled");
      if(borough == "Manhattan") {
          $('#manhattan_form').show();
      } else if(borough == "Brooklyn") {
          $('#brooklyn_form').show();
      }
  });

  $('.dropdown').change(function(event){
      var neighborhoodID = $(this).find("select").val();
      if(neighborhoodID == "") {
          $('.submit').addClass("disabled");
      } else {
          $('.submit').removeClass("disabled");
      }
  });

   $(document).ready(function(){
    $('#results-text').hide()
   	$("#search-again").hide();
    $(".load").hide();
   }).ajaxStart(function () {
       $(".load").show();
    }).ajaxStop(function () {
      $('#results-text').show()
      $("#search-again").show();
      $(".load").hide();
   });

});

