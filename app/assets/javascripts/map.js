var drawMap = function drawMap() {
  var heatMapData = [];
  var location;
  var endPoint;

  for (var i = 0; i < gon.locations.length; i++) {
    location = gon.locations[i];
    endPoint = new google.maps.LatLng(location.latitude, location.longitude);
    heatMapData.push(endPoint);
  };

  var mapOptions = {
    center: new google.maps.LatLng(gon.latitude, gon.longitude),
    zoom: 15
  };
  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
  var heatmap = new google.maps.visualization.HeatmapLayer({
    data: heatMapData
  });
  heatmap.setMap(map)
}

google.maps.event.addDomListener(window, 'load', drawMap);