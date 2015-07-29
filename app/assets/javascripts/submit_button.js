$(function() {

$("#manhattan").click(function(){
    $("#manhattan_form").show();
    $("#manhattan").hide();
    $("#brooklyn_form").hide();
});

$("#brooklyn").click(function(){
    $("#brooklyn_form").show();
    $("#brooklyn").hide();
    $("#manhattan_form").hide();
});
});
