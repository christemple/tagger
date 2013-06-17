def get_tagger_collection
  return @db_connection.collection('tagger') if @db_connection
  db = URI.parse(settings.mongodb)
  db_name = db.path.gsub(/^\//, '')
  @db_connection = Mongo::MongoClient.new(db.host, db.port).db(db_name)
  @db_connection.authenticate("user", "wombat")
  @db_connection.collection('tagger')
end
