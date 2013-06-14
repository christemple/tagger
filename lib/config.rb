require 'uri'

configure do
  set :port, 3000
  set :root, File.dirname("../")
  set :mongodb, "http://localhost:27017/test"
end


configure :production do
  set :mongodb, ENV['MONGOHQ_URL']
end
