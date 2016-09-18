@loadSessions = (map) ->
  icon = L.icon
    iconUrl: 'images/woopin.png',
    iconSize: [25, 38],
    iconAnchor: [12.5, 38],
    popupAnchor: [1, -38]

  $.get '/sessions', (sessions) ->
    markers = L.markerClusterGroup(
      iconCreateFunction: clusterIcon
    )

    for session in sessions
      marker = L.marker(
        [session.spot.location.lat, session.spot.location.lng],
        icon: icon
      )
      marker.bindPopup(
        sessionDetails(session),
        maxWidth: 400
      )
      markers.addLayer(marker)

    map.addLayer(markers)
    setTimeout(loadSessions, 30000)

@clusterIcon = (cluster) ->
  L.divIcon(
    className: 'marker-cluster',
    iconSize: L.point(32, 32),
    html: "
      <div class='marker-cluster--inner'>
        <span class='marker-cluster--count'>
          #{cluster.getChildCount()}
        </span
      </div>"
  )

@sessionDetails = (session) ->
  user_picture = session.pictures.filter((pic) -> pic.type == 'user')[0]
  session_picture = session.pictures.filter((pic) -> pic.type == 'session')[0]

  "<div class='session-details'>" +
    (if user_picture? then "
    <div class='session-details--profile-picture'>
      <img src='#{user_picture.url}'></img
    <div>" else '') + "
    <h1>#{session.user_name}</h1>
    <div class='session-details--meta'>
      <div class='session-details--description'>
        <div>#{session.description}</div>
        <div>at #{session.spot.name}</div>
      </div>
      <div class='session-details--location'>#{session.finished_at}</div>
    </div>" +
    (if session_picture? then "
      <div class='session-details--picture'>
        <img src='#{session_picture.url}'></img>
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

$ ->
  map = L.map('map').setView([28.3, 20.8], 3)

  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox.streets-satellite',
    accessToken: $('#map').data().mapboxAccessToken
  }).addTo(map)
  loadSessions(map)
