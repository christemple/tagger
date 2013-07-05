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
  @selected_tags = params['selected_tags'] || []
  @results = $tagger.aggregate([{'$match' => { tags: {'$all' => @selected_tags}, called_call_centre: true }},
                                {'$group' => {'_id' => '$date_called', 'total_calls' => {'$sum' => 1}}},
                                {'$sort' => { _id: 1 }}
                               ])
  dates = @results.collect { |result| result["_id"] }
  total_calls = @results.collect { |result| result["total_calls"] }
  @chart_data = <<-JSON
    {
        "labels" : #{dates},
        "datasets" : [
            {
                "fillColor" : "rgba(151,187,205,0.5)",
                "strokeColor" : "rgba(151,187,205,1)",
                "pointColor" : "rgba(151,187,205,1)",
                "pointStrokeColor" : "#fff",
                "data" : #{total_calls}
            }
        ]
    }
  JSON
  @total = @results.inject(0) {|total, result| total += result['total_calls'] }
  erb :index
end

