require 'net/http'
require 'json'
class HereMap
  here_key = ENV["HERE_MAP_ID"]
  here_code = ENV["HERE_MAP_CODE"]

  def self.search time
    uri = create_query_uri time
    res = Net::HTTP.get_response(uri)
    return 'API Query Error' unless res.is_a?(Net::HTTPSuccess)
    nearest =  nearest_point res.body
    puts nearest
  end

  def self.create_query_uri time
    url_string = "https://isoline.route.cit.api.here.com/routing/7.2/calculateisoline.json"
      params = {
      :app_id=> ENV["HERE_MAP_ID"],
      :app_code=> ENV["HERE_MAP_CODE"],
      :mode=>"shortest;car;traffic:enabled",
      :start=>"geo!-37.008056,174.791667,14",
      :range=>time*60*60,
      :rangetype=>"time"}
    uri = URI(url_string)
    uri.query = URI.encode_www_form(params)
    uri
  end

  def self.nearest_point body
    my_hash = JSON.parse(body)
    hash2 = my_hash["response"]["isoline"][0]
    points = hash2["component"][0]["shape"]
    distance = 0
    nearest = ""
    points.each do |point|
      koordinates_point = point.split(",")
      current_distance = calculate_distance koordinates_point
      distance = current_distance if distance == 0
      nearest = point if distance > current_distance
      distance = current_distance if distance > current_distance
    end
    nearest
  end
  def self.calculate_distance point
    x = point[0]
    y = point[1]
    square = (x.to_f-(-37.008056))*(x.to_f-(-37.008056))+(y.to_f-174.791667)*(y.to_f-174.791667)
    Math.sqrt(square)
  end
end
