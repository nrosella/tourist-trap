var drawMap = function drawMap() {
  var heatMapData = [];
  var location;
  var endPoint;
  var latLng;
  var marker;

  // creates array of gooogle maps LatLngs 
  for (var i = 0; i < gon.locations.length; i++) {
    location = gon.locations[i];
    endPoint = new google.maps.LatLng(location.latitude, location.longitude);
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

  // Draws markers
  for (var i = 0; i < gon.locations.length; i++) {
    location = gon.locations[i];
    marker = new google.maps.Marker({
      position: new google.maps.LatLng(location.latitude, location.longitude),
      map: map,
      title: location.name,
      animation: google.maps.Animation.DROP
    });
  };
}

google.maps.event.addDomListener(window, 'load', drawMap);