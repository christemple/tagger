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

  #css_compression :css
}

def get_tagger_collection
  return @db_connection.collection('tagger') if @db_connection
  db = URI.parse(settings.mongodb)
  db_name = db.path.gsub(/^\//, '')
  @db_connection = Mongo::MongoClient.new(db.host, db.port).db(db_name)
  @db_connection.authenticate("user", "wombat")
  @db_connection.collection('tagger')
end


include Mongo
$tagger = get_tagger_collection

get '/' do
  erb :index
end

post '/' do
  @selected_tags = params['selected_tags']
  @results = $tagger.find('tags' => {'$all' => @selected_tags})
  erb :tags
end

