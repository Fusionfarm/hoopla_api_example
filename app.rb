require 'sinatra'
require 'httparty'

config = YAML.load_file('config.yml')

get '/hi' do
  "Hello World!"
end