require 'sinatra'
require 'httparty'
require 'haml'

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