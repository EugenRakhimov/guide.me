class Koordinate
  def get_historical places
  end

  def self.search
    uri = create_query_uri
    res = Net::HTTP.get_response(uri)
    return 'API Query Error' unless res.is_a?(Net::HTTPSuccess)
    my_hash = JSON.parse(res.body)
    features = my_hash["vectorQuery"]["layers"]["1304"]["features"]
    features.map { |e| {coordinates:e["geometry"]["coordinates"], name:e["properties"]["Name"],
      address:e["properties"]["Address"], distance:e["properties"]["distance"]} }
  end

  def self.create_query_uri
    url_string = "https://koordinates.com/services/query/v1/vector.json"
      params = {
        :key=>ENV["KOORDINATES"],
        :layer=>1304,
        :x=>174.791667,
        :y=>-37.008056,
        :max_results=>100,
        :radius=>10000,
        :geometry=>'true',
        :with_field_names=>'true'}
    uri = URI(url_string)
    uri.query = URI.encode_www_form(params)
    puts uri
    uri
  end

end
