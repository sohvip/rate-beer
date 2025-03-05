class RatingsController < ApplicationController
  def index
    @recent_ratings = Rating.recent
    @top_beers = Beer.top 3
    @top_breweries = Brewery.top 3
    @top_styles = Style.top 3
    @top_users = User.top 3
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
