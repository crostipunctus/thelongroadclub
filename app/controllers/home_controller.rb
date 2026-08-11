class HomeController < ApplicationController
  def index
    @topics = Discussion.fresh.includes(:category, :user).limit(4)
    @events = Event.published.upcoming.limit(2)
    @garage_feature = GarageFeature.published.order(featured: :desc, published_at: :desc).first
    @guides = Guide.published.limit(3)
    @bookmarked_ids = current_user ? current_user.bookmarks.where(discussion_id: @topics.map(&:id)).pluck(:discussion_id).to_set : Set.new
  end
end
