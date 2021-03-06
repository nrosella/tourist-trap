var drawMap = function drawMap() {
  var heatMapData = [];
  var location;
  var endPoint;
  var latLng;
  var marker;

  // creates array of gooogle maps LatLngs 
  for (var i = 0; i < gon.locations.length; i++) {
    location = gon.locations[i];
    endPoint = {
      location: new google.maps.LatLng(location.latitude, location.longitude),
       weight: location.rating
     };
    heatMapData.push(endPoint);
  };

  // sets map canvas options
  var mapOptions = {
    center: new google.maps.LatLng(gon.latitude, gon.longitude),
    zoom: 15
  };

  // Draws Map Canvas
  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

  // sets heatmap options
  var heatmap = new google.maps.visualization.HeatmapLayer({
    data: heatMapData,
    radius: 20
  });

  // Draws heatmap
  heatmap.setMap(map);
}

google.maps.event.addDomListener(window, 'load', drawMap);
$(document).ajaxStop(drawMap);

console.log("Hello, world!")