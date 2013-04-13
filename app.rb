require 'sinatra'
require 'httparty'
require 'haml'
require 'multi_json'
require 'json'

set :views, Proc.new { File.join(root, "views") }

config = YAML.load_file('config.yml')

def get_categories
 %w(
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
end

get '/hi' do
  "Hello World!"
end

get '/events/new' do
  @categories = get_categories
  haml :'events/new'
end

post '/events' do
  require 'time'
  start_date = Time.parse("#{params[:event_date]} #{params[:start_time]}")
  end_date = Time.parse("#{params[:event_date]} #{params[:end_time]}")
  end_date += (24*60*60) if end_date < start_date
  response = HTTParty.post("http://events.hooplanow.com/api/v1/events.json", 
    body: { 
      key: config['apikey'], 
      event: { 
        name: params[:name], 
        description: params[:description] 
      },
      dates: [
        { 
          start: start_date.strftime("%B %e, %Y %H:%I"), 
          end: end_date.strftime("%B %e, %Y %H:%I")
        }
      ],
      tags: params[:tags]
    })
  body = MultiJson.load(response.body, :symbolize_keys => true)
  @valid = body[:valid]
  @error_messages = body[:error_messages] unless @valid
  @categories = get_categories
  haml :'events/new'
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

  haml :'events/index'
end