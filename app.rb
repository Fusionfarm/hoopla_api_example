require 'sinatra'
require 'httparty'
require 'haml'
require 'multi_json'

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

post '/search-places' do
end

get '/events/' do
  @stylesheet_url = params[:stylesheet_url]
  @stylesheet_url = '/default.css' if params[:stylesheet_url].nil?

  other_params = params.map{|key,value| "#{key}=#{value}" }.join('&')

  response = HTTParty.get("http://events.hooplanow.com/api/v1/events.json?key=#{config['apikey']}&#{other_params}")
  @events = MultiJson.load(response.body, :symbolize_keys => true)

  haml :'events/index'
end