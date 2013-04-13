require 'sinatra'
require 'httparty'
require 'haml'

set :views, Proc.new { File.join(root, "views") }

config = YAML.load_file('config.yml')

get '/hi' do
  "Hello World!"
end

get '/events/new' do
  haml :'events/new'
end