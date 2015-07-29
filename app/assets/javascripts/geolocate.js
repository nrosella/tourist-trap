$(function() {
  $('#geolocate').click(function(event) {
    if ("geolocation" in navigator) {
      navigator.geolocation.getCurrentPosition(function(position) {
        var latitude = position.coords.latitude;
        var longitude = position.coords.longitude;
        $('#latitude').val(latitude);
        $('#longitude').val(longitude);
      });
    } else {
      console.log("Geolocation is not available");
    }
  });
});