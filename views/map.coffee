@loadSessions = (map, markers=[], markerClusterGroup=L.markerClusterGroup(iconCreateFunction: clusterIcon), lastUpdatedAt=null) ->
  # When requesting sessions, convert the timestamp from milliseconds to seconds
  $.get '/sessions', ({last_updated_at: (lastUpdatedAt / 1000).toFixed()} if lastUpdatedAt?), (sessions) ->
    for session in sessions
      marker = L.marker(
        [session.spot.location.lat, session.spot.location.lng],
        title: "#{session.user_name} @ #{session.spot.name} (#{session.finished_at})",
        session_finished_at: new Date(session.finished_at_timestamp),
        icon: L.icon
          iconUrl: 'images/woopin.png',
          iconSize: [25, 38],
          iconAnchor: [12.5, 38],
          popupAnchor: [1, -38]
      )
      marker.bindPopup(
        sessionDetails(session),
        maxWidth: 400
      )
      markers.push(marker)

    expiredMarkers = filterExpiredMarkers(markers)
    markers = (marker for marker in markers when marker not in expiredMarkers)

    markerClusterGroup.addLayers(markers)
    markerClusterGroup.removeLayers(expiredMarkers)
    map.addLayer(markerClusterGroup)

    lastUpdatedAt = $.now()
    setTimeout((-> loadSessions(map, markers, markerClusterGroup, lastUpdatedAt)), 30000)

# Markers of sessions that were posted more than 24 hours ago
@filterExpiredMarkers = (markers) ->
  markers.filter (marker) ->
      marker.options.session_finished_at < new Date($.now() - 1000 * 60 * 60 * 24)

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
  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}', {
    attribution: '<a href="https://github.com/JanBe/woo-map">WOO Map @ GitHub</a> | Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> © <a href="http://mapbox.com">Mapbox</a>',
    maxZoom: 18,
    id: 'mapbox.streets-satellite',
    accessToken: $('#map').data().mapboxAccessToken
  }).addTo(map)

  loadSessions(map)
