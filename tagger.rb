$LOAD_PATH.unshift File.expand_path('lib')
require 'sinatra'
require 'sinatra/assetpack'
require 'thin'
require 'config'
require 'mongo'
require 'helpers'
require 'database'

register Sinatra::AssetPack
assets {
  css :app, ['/css/*.css']
  js :app, ['/js/*.js']
}

include Mongo
$tagger = get_tagger_collection

get '/' do
  erb :index
end

post '/' do
  @selected_tags = []
  @selected_tags = params['selected_tags'] if params['selected_tags']
  @results = $tagger.find(tags: {'$all' => @selected_tags}, called_call_centre: true).sort({ date_called: -1 })
  erb :index
end

