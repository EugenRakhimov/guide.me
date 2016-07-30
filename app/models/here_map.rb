require 'net/http'
class HereMap
  here_key = ENV["HERE_MAP_ID"]
  here_code = ENV["HERE_MAP_CODE"]

  def self.search time
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
    res = Net::HTTP.get_response(uri)
    puts res.body if res.is_a?(Net::HTTPSuccess)
    puts time
  end
end
