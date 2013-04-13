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

# Example:
#
#     /events.json?callback=foo&event_categories[]=1
get '/events.json' do
  callback = params[:callback]
  id = params[:event_categories].first.to_i

  parsed = HTTParty.get("http://events.hooplanow.com/api/v1/events.json?key=#{ config['apikey'] }&event_categories[]=#{ id }")
  json = MultiJson.dump(parsed)

  if callback
    "#{ callback }(#{ json })"
  else
    json
  end
end

get '/events/' do
  @stylesheet_url = params[:stylesheet_url]
  @stylesheet_url = '/default.css' if params[:stylesheet_url].nil?

  other_params = params.map do |key,value|
    key_value = ""
    if value.is_a?(Array)
      key_value = value.map{|item| "#{key}[]=#{item}"}.join('&')
    else
      key_value = "#{key}=#{value}"
    end
    key_value
  end.join('&')

  response = HTTParty.get("http://events.hooplanow.com/api/v1/events.json?key=#{config['apikey']}&#{other_params}")
  @events = MultiJson.load(response.body, :symbolize_keys => true)

  if params[:widget] == "true"
    haml :'events/widget'
  else
    haml :'events/index'
  end
end
