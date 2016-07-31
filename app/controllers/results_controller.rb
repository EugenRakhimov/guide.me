class ResultsController < ApplicationController
  def show
    @mapID = ENV["HERE_MAP_ID"]
    @map_code = ENV["HERE_MAP_CODE"]
    render "show"
  end
end
