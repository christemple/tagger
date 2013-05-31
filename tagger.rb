require 'sinatra'
require 'thin'
require 'mongo'

configure do
  set :port, 3000
end

include Mongo

$tagger = MongoClient.new.db('test').collection('tagger')

get '/' do
  erb :index
end

post '/' do
  @selected_tags = params['selected_tags']
  @results = $tagger.find('tags' => {'$all' => @selected_tags})
  erb :tags
end

