$LOAD_PATH.unshift File.expand_path('lib')
require 'sinatra'
require 'sinatra/assetpack'
require 'thin'
require 'config'
require 'mongo'
require 'helpers'

register Sinatra::AssetPack
assets {
  css :app, ['/css/*.css']
  js :app, ['/js/*.js']

  css_compression :css
}

include Mongo
$tagger = MongoClient.new(settings.mongodb).db('test').collection('tagger')

get '/' do
  erb :index
end

post '/' do
  @selected_tags = params['selected_tags']
  @results = $tagger.find('tags' => {'$all' => @selected_tags})
  erb :tags
end

