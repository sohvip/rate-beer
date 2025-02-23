class PlacesController < ApplicationController
  before_action :set_place, only: %i[show]
  def index
  end

  def show
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    @weather = WeatherApi.weather_in(params[:city])
    session[:last_search] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index, status: 418
    end
  end

  private

  def set_place
    places = Rails.cache.read(session[:last_search])
    @place = places.find { |place| place[:id] == params[:id] }
  end
end
