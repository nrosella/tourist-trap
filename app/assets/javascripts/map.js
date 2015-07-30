var drawMap = function drawMap() {
  var latitude = Number($('#latitude').text());
  var longitude = Number($("#longitude").text());
  console.log(latitude);
  console.log(longitude);
  var mapOptions = {
    center: new google.maps.LatLng(latitude, longitude),
    zoom: 15
  };
  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
}

google.maps.event.addDomListener(window, 'load', drawMap);