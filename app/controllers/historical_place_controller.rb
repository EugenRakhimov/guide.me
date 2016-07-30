class HistoricalPlaceController < ApplicationController

  def index
    render :text=>"Show Historical places"
  end

  def show
    render :text=>"Show Historical places"
  end

  def search
    puts params
    render :text=>"Search historical_place"
  end

end
