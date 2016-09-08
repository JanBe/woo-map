this.initMap = ->
  map = new (google.maps.Map)(document.getElementById('map'),
    center:
      lat: 28.3
      lng: 20.8
    zoom: 3
  )
