require 'uri'

configure do
  set :port, 3000
  set :root, File.dirname("../")
  set :mongodb, "localhost"
end


configure :production do
  set :mongodb, URI.parse(ENV['MONGOHQ_URL'])
end
