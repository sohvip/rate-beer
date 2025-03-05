class RatingsController < ApplicationController
  def index
    @recent_ratings = Rating.recent
    Rails.cache.fetch("beer top 3", expires_in: 10.minutes) do
      Beer.top(3)
    end
    @top_beers = Rails.cache.read("beer top 3")
    Rails.cache.fetch("brewery top 3", expires_in: 10.minutes) do
      Brewery.top(3)
    end
    @top_breweries = Rails.cache.read("brewery top 3")
    Rails.cache.fetch("style top 3", expires_in: 10.minutes) do
      Style.top(3)
    end
    @top_styles = Rails.cache.read("style top 3")
    Rails.cache.fetch("user top 3", expires_in: 10.minutes) do
      User.top(3)
    end
    @top_users = Rails.cache.read("user top 3")
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    expire_fragment('brewerylist')
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    expire_fragment('brewerylist')
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to request.referer || ratings_path
  end
end
