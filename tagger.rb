$LOAD_PATH.unshift File.expand_path('lib')
require 'sinatra'
require 'sinatra/assetpack'
require 'thin'
require 'mongo'
require 'helpers'

configure :development do
  set :port, 3000
  set :root, File.dirname(__FILE__)
end

configure :production do
  set :port, 3000
  set :root, File.dirname(__FILE__)
end

register Sinatra::AssetPack
assets {
  css :app, ['/css/*.css']
  js :app, ['/js/*.js']

  css_compression :css
}

include Mongo
$tagger = MongoClient.new.db('test').collection('tagger')

get '/' do
  puts "Config: #{settings.environment}"
  erb :index
end

post '/' do
  @selected_tags = params['selected_tags']
  @results = $tagger.find('tags' => {'$all' => @selected_tags})
  erb :tags
end

