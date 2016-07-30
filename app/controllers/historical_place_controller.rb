class HistoricalPlaceController < ApplicationController

  def index
    render :text=>"Show Historical places"
  end

  def show
    render :text=>"Show Historical places"
  end

  def search
    time_available = params[:hour]
    HereMap.search time_available.to_i / 2
    render :text=>"Search historical_place"
  end

end
