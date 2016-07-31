class HistoricalPlaceController < ApplicationController

  def index
    render :text=>"Show Historical places"
  end

  def show
    render :text=>"Show Historical places"
  end

  def search
    time_available = params[:hour]
    js = HereMap.search time_available.to_i
    render :json=>js
  end

end
