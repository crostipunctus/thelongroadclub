class GarageFeaturesController < ApplicationController
  def index
    @garage_features = GarageFeature.published.order(featured: :desc, published_at: :desc)
  end

  def show
    @garage_feature = GarageFeature.published.find_by!(slug: params[:slug])
  end
end
