require 'sinatra'
require 'slim'
require 'sass'
require 'coffee-script'

get '/' do
  slim :index
end

get '/map.js' do
  coffee :map
end

get '/map.css' do
  sass :map
end
