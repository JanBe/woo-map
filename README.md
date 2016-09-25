# WOO Map

This application fetches sessions from the [woosports.com](https://woosports.com/) API and displays them on a map. Newly posted sessions are automatically added every 30 seconds.

The sessions are those from the "community" tab of the "activity" view of the app. The map only displays sessions that were posted during the last 24 hours. When loading new sessions, it also removes sessions from the map that are now older than 24 hours.

The aim of this is to put the map on an unused screen and see where people are kiting all around the world during the day.

## Demo
A Heroku hosted instance of the map can be found here: [woo-map.herokuapp.com](https://woo-map.herokuapp.com/)

## Further Development
These are the ideas I currently have for extending the functionality of the map. If you have suggestions, feel free to contact me or add them as [issues](https://github.com/JanBe/woo-map/issues).

* Use an endpoint of the WOO-API that returns all recent sessions instead of the "community"-view. Currently only sessions > 5m height are displayed.
* When an endpoint is used that returns all sessions, use a [day-night cycle overlay](http://joergdietrich.github.io/Leaflet.Terminator/) to see how the sessions move with the daylight. Currently the amount of sessions is not high enough for that.
* Add a [Windity](https://www.windyty.com) overlay to display the current wind around the world. Ideally, adjust the current time of the overlay to a session when its details-window is opened.
* Use a background job to load new sessions instead of checking for the necessity of an update on every call to `/sessions`.
* Also show Wake and Kite Freestyle sessions from [WOO 2.0](https://woosports.com/wake/) as soon as more of them pop up.
* Maybe switch from Sinatra to Rails as a framework. This project started out without a database and with a super simple backend, the current functionality probably justifies the use of Rails.

## Project Setup
This sections describes the steps to set up the application locally on your machine.

### Prerequisites

To run this application you need at least:

* Bundler
* Ruby 2.3.1
* Postgresql 9.4

### Setup

1. Clone the repository `git clone https://github.com/JanBe/woo-map`
2. `cd woo-map`
3. `bundle install` to install gems
4. `rake db:setup` to set up the database
5. `cp .env.sample .env` to copy sample environment variables file
6. Fill in `.env`, `WOO_TOKEN_APP_URL` refers to an instance of [this application](https://github.com/JanBe/woo-token)
7. `rackup` to start the server
