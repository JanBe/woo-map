/*! Copyright (c) Windyty SE, 2016 all rights reserved */ ! function() {
    function a(a, b) {
        var c = document.createElement("script");
        c.type = "text/javascript", document.head.appendChild(c), c.async = !0, c.onload = b || function() {}, c.onerror = function() {
            console.error("Failed to load" + a)
        }, c.src = a
    }

    function b(a) {
        var b = document.createElement("link");
        b.rel = "stylesheet", b.href = a, document.head.appendChild(b)
    }

    function c(a) {
        throw alert(a), a
    }

    function d() {
        W.require(f, function(a) {
            W.setTimestamp = W.windytyUI.setTimestamp.bind(W.windytyUI), W.setOverlay = W.windytyUI.setOverlay.bind(W.windytyUI), W.setLevel = W.windytyUI.setLevel.bind(W.windytyUI), W.timeline = W.windytyUI.calendar, W.on = W.broadcast.on.bind(W.broadcast), W.off = W.broadcast.off.bind(W.broadcast), W.once = W.broadcast.once.bind(W.broadcast), W.fire = W.broadcast.emit.bind(W.broadcast), initMap(a)
        })
    }

    function e() {
        ref = document.URL, ga("create", "UA-56263486-8", {
            name: "b"
        }), ga("b.send", "pageview", "key/" + document.getElementById('windytv-script').dataset.windytvApiKey), ga("b.send", "pageview", "source/" + ref)
    }
    var f = ["maps", "prototypes", "rootScope", "broadcast", "object", "mapsCtrl", "trans", "broadcast", "calendar", "http", "jsonLoader", "overlays", "products", "colors", "legend", "windytyUI", "windytyCtrl"];
    API_MODE = !0, DEBUG = !0, DEBUG2 = !1, L || c("Missing Leaflet library. Add leaflet library into HEAD seaction of your code"), /0.7.5|0.7.7/.test(L.version) || c("Wrong version of Leaflet library. Version 0.7.5 or 0.7.7 required"), document.getElementById('windytv-script').dataset.windytvApiKey|| c("Missing API key"), window.initMap|| c("Missing function named initMap");
    var g = "https://api.windytv.com/v2.0/",
        h = document.getElementById("map");
    h || c("Missing DIV with map id"), h.innerHTML = '<div id="map_container" style="width:100%; height:100%;"></div><div id="contrib">OSM & contributors</div><div id="legend"></div><canvas id="jpg_decoder" style="display: none;"></canvas><div id="globe_container"></div><a class="logo" href="https://www.windytv.com" target="wndt"><img class="w" src="https://www.windytv.com/img/logo.svg"><img class="text" src="https://www.windytv.com/img/logo_windyty_11.svg"></a>', b("/stylesheets/windytv-2.0/api.css"), a("https://www.windytv.com/gfs/minifest.js", function() {
        a("/javascripts/windytv-2.0/api.js?key=" + document.getElementById('windytv-script').dataset.windytvApiKey, d)
    }), setTimeout(function() {
        "function" == typeof ga ? e() : a("https://www.google-analytics.com/analytics.js", e)
    }, 5e3)
}();
