@initMap = ->
  map = new (google.maps.Map)(document.getElementById('map'),
    center:
      lat: 28.3
      lng: 20.8
    zoom: 3
    disableDefaultUI: true,
    zoomControl: true
  )
  loadSessions(map)

@loadSessions = (map) ->
  $.get '/sessions', (sessions) ->
    for session in sessions
      new google.maps.Marker(
        position: session.spot.location,
        map: map,
        title: session.user_last_name
      )
