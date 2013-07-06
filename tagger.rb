$LOAD_PATH.unshift File.expand_path('lib')
require 'sinatra'
require 'sinatra/assetpack'
require 'thin'
require 'config'
require 'mongo'
require 'helpers'
require 'database'
require "json"

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
  @selected_tags = params['selected_tags'] || []
  @results = $tagger.aggregate([{'$match' => { tags: {'$all' => @selected_tags}, called_call_centre: true }},
                                {'$group' => {'_id' => '$date_called', 'total_calls' => {'$sum' => 1}}},
                                {'$sort' => { _id: 1 }}
                               ])
  @chart_data = @results.collect { |result| { day: DateTime.parse(result["_id"]).strftime("%Y-%m-%d"), calls: result["total_calls"] } }.to_json
  @total = @results.inject(0) {|total, result| total += result['total_calls'] }
  erb :index
end

