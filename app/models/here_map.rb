require 'net/http'
require 'json'
class HereMap
  here_key = ENV["HERE_MAP_ID"]
  here_code = ENV["HERE_MAP_CODE"]

  def self.search time
    uri = create_query_uri time
    res = Net::HTTP.get_response(uri)
    return 'API Query Error' unless res.is_a?(Net::HTTPSuccess)
    boundary = points res.body
    nearest =  nearest_point boundary
    koordinates = Koordinate.search
    result = koordinates_in_boundaries( koordinates, nearest)
    calculate_routes(result, time)
  end

  def self.calculate_routes koordinates, time
    routes = []
    koordinates.each do |koordinate1|
      koordinates.each do |koordinate2|
        koordinates.each do |koordinate3|
          if((koordinate1!=koordinate2)&&(koordinate2!=koordinate3)&&(koordinate1!=koordinate3))
             route = get_route(koordinate1, koordinate2, koordinate3)
             routes.push(route["route"][0]) if (route["route"][0]["summary"]["travelTime"] + (60*30)*3 < time*60*60)
             route if (route["route"][0]["summary"]["travelTime"] + (60*30)*3 < time*60*60)
             return routes if routes.count >3
          end
        end
      end
    end

  end


  def self.koordinates_in_boundaries koordinates, nearest
   reduced =  koordinates.select { |koordinate|  check_point koordinate[:coordinates], nearest}
   reduced
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

  def self.points body
    my_hash = JSON.parse(body)
    hash2 = my_hash["response"]["isoline"][0]
    points = hash2["component"][0]["shape"]
  end

  def self.check_point point, nearest
    point2 = [point[1], point[0]]
    return true if (calculate_distance(point2) < calculate_distance(nearest))
    return false
  end

  def self.nearest_point points
    distance = 0
    nearest = ""
    points.each do |point|
      koordinates_point = point.split(",")
      current_distance = calculate_distance koordinates_point
      distance = current_distance if distance == 0
      nearest = koordinates_point if distance > current_distance
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
  def self.koorinate_to_api koordinate
    y = koordinate[:coordinates][0]
    x = koordinate[:coordinates][1]
    "#{x},#{y}"
  end
  def self.route_url waypoint1, waypoint2, waypoint3

    url_string ="https://route.cit.api.here.com/routing/7.2/calculateroute.json"
    params = {
      :app_id=> ENV["HERE_MAP_ID"],
      :app_code=> ENV["HERE_MAP_CODE"],
      :waypoint0=>"geo!-37.008056,174.791667,14",
      :waypoint1=>"geo!"+koorinate_to_api(waypoint1),
      :waypoint2=>"geo!"+koorinate_to_api(waypoint2),
      :waypoint3=>"geo!"+koorinate_to_api(waypoint3),
      :waypoint4=>"geo!-37.008056,174.791667,14",
      :mode=>"fastest;car;traffic:enabled"}
    uri = URI(url_string)
    uri.query = URI.encode_www_form(params)
    uri
  end

  def self.get_route  waypoint1, waypoint2, waypoint3
    uri = route_url  waypoint1, waypoint2, waypoint3
    res = Net::HTTP.get_response(uri)
    return 'API Query Error' unless res.is_a?(Net::HTTPSuccess)
    JSON.parse(res.body)["response"]
  end
end
