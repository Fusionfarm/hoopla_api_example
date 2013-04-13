require 'sinatra'
require 'httparty'
require 'haml'
require 'multi_json'
require 'json'

set :views, Proc.new { File.join(root, "views") }

config = YAML.load_file('config.yml')

get '/hi' do
  "Hello World!"
end

get '/events/new' do
  @categories = %w(
    Arts
    Auditions
    Comedy
    Dance
    Exhibits
    Farmers Market
    Festival/Fairs
    Theatre/Film
    Fitness/Recreation
    Food/Wine/Beer
    Music
    Pets
    Bazaars/Flea Markets/Craft Sales
    Seasonal
    Sports
    Movies
    Literary
    Children's
    Outdoors
    School plays
    School concerts
    St. Patrick's Day
    Business/Networking
    Fundraisers/Benefits
    Lectures/Discussions
    Seminars/Workshops
    Valentine's Day
  )
  haml :'events/new'
end

post '/events' do
end

post '/search-places.json' do
  content_type :json
  response = HTTParty.get("http://events.hooplanow.com/api/v1/places.json", 
    query: { key: config['apikey'], keywords: params[:keywords] })
  @places = response.body
  @places
end

get '/place.json' do
  content_type :json
  response = HTTParty.get("http://events.hooplanow.com/api/v1/places/#{params[:id]}.json",
    query: { key: config['apikey'] })
  @place = response.body
  @place
end

get '/events/' do
  response = HTTParty.get("http://events.hooplanow.com/api/v1/events.json?key=#{config['apikey']}")
  @events = MultiJson.load(response.body, :symbolize_keys => true)
  haml :'events/index'
end