@initMap = ->
  map = new (google.maps.Map)(document.getElementById('map'),
    center:
      lat: 28.3
      lng: 20.8
    zoom: 3
    disableDefaultUI: true,
    zoomControl: true,
    mapTypeControl: true
  )
  setDayNightCycleOverlay(map)
  loadSessions(map)

@loadSessions = (map) ->
  icon = {
    url: 'images/woopin.png',
    size: new google.maps.Size(50, 75),
    scaledSize: new google.maps.Size(25, 38),
    anchor: new google.maps.Point(12.5, 38)
  }
  sessionDetailsWindow = initializeSessionDetailsWindow()

  $.get '/sessions', (sessions) ->
    for session in sessions
      marker = new google.maps.Marker(
        position: session.spot.location,
        map: map,
        title: session.user_last_name,
        icon: icon
        anchorPoint: new google.maps.Point(0, -38),
        session: session
      )
      google.maps.event.addListener marker, 'click', ->
        sessionDetailsWindow.setContent(sessionDetails(this.session))
        sessionDetailsWindow.open(map, this)

    setTimeout(loadSessions, 30000)

@initializeSessionDetailsWindow = ->
  new google.maps.InfoWindow(
    content: 'Loading...',
    maxWidth: 400
  )

@sessionDetails = (session) ->
  "<div class='session-details'>" +
    (if session.user_pictures? && session.user_pictures.user? then "
    <div class='session-details--profile-picture'>
      <img src='#{session.user_pictures.user}'></img
    <div>" else '') + "
    <h1>#{session.user_name}</h1>
    <div class='session-details--meta'>
      <div class='session-details--description'>
        <div>#{session.description}</div>
        <div>at #{session.spot.name}</div>
      </div>
      <div class='session-details--location'>#{session.session_finished}</div>
    </div>" +
    (if session.picture? then "
      <div class='session-details--picture'>
        <img src='#{session.picture}'></img>
      </div>"
    else '') + "
    <p>
    <div class=session-details--stats>
      <div class='session-details--stat'>
        <div class='session-details--stat-figure'>
          <b>#{session.highest_jump.toFixed(1)}m</b>
        </div>
        Highest Jump
      </div>
      <div class='session-details--stat'>
        <div class='session-details--stat-figure'>
          <b>#{session.max_airtime}</b>
        </div>
        Max Airtime
      </div>
      <div class='session-details--stat'>
        <div class='session-details--stat-figure'>
          <b>#{session.max_crash_power.toFixed(1)}G</b>
        </div>
        Landing
      </div>
    </div>
    <div class=session-details--stats>
      <div class='session-details--stat'>
        <div class='session-details--stat-figure'>
          <b>#{session.total_height.toFixed(1)}m</b>
        </div>
        Total Height
      </div>
      <div class='session-details--stat'>
        <div class='session-details--stat-figure'>
          <b>#{session.total_airtime}</b>
        </div>
        Total Airtime
      </div>
      <div class='session-details--stat'>
        <div class='session-details--stat-figure'>
          <b>#{session.duration}</b>
        </div>
        Session Duration
      </div>
    </div>
    <div class=session-details--stats>
      <div class='session-details--stat'>
        <div class='session-details--stat-figure'>
          <b>#{session.likes}</b>
        </div>
        Likes
      </div>
      <div class='session-details--stat'>
        <div class='session-details--stat-figure'>
          <b>#{session.comments}</b>
        </div>
        Comments
      </div>
      <div class='session-details--stat'>
        <div class='session-details--stat-figure'>
          <b>#{session.number_of_jumps}</b>
        </div>
        Jumps
      </div>
    </div>
  </div>"

@setDayNightCycleOverlay = (map) ->
  nite.init(map)
  setTimeout(setDayNightCycleOverlay, 30000)
