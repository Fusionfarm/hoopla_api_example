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
  haml :'events/new'
end

get '/events/' do
  response = HTTParty.get("http://events.hooplanow.com/api/v1/events.json?key=#{config['apikey']}")
  @events = MultiJson.load(response.body, :symbolize_keys => true)
  haml :'events/index'
end