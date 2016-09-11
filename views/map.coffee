@initMap = ->
  map = new (google.maps.Map)(document.getElementById('map'),
    center:
      lat: 28.3
      lng: 20.8
    zoom: 3
    disableDefaultUI: true,
    zoomControl: true
  )
  setDayNightCycleOverlay(map)
  loadSessions(map)

@loadSessions = (map) ->
  $.get '/sessions', (sessions) ->
    marker = {
      url: 'images/woopin.png',
      size: new google.maps.Size(50, 75),
      scaledSize: new google.maps.Size(25, 38)
    }

    for session in sessions
      new google.maps.Marker(
        position: session.spot.location,
        map: map,
        title: session.user_last_name,
        icon: marker
      )
    setTimeout(loadSessions, 30000)

@setDayNightCycleOverlay = (map) ->
  nite.init(map)
  setTimeout(setDayNightCycleOverlay, 30000)
