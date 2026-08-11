class BookmarksController < ApplicationController
  before_action :require_authentication
  before_action :set_discussion

  def create
    bookmark = current_user.bookmarks.find_or_create_by!(discussion: @discussion)
    respond_to do |format|
      format.html { redirect_back fallback_location: @discussion, notice: "Discussion saved." }
      format.json { render json: { bookmarked: true, id: bookmark.id }, status: :created }
    end
  end

  def destroy
    current_user.bookmarks.find_by(discussion: @discussion)&.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: @discussion, notice: "Bookmark removed." }
      format.json { render json: { bookmarked: false } }
    end
  end

  private

  def set_discussion
    @discussion = Discussion.find_by!(slug: params[:discussion_slug])
  end
end
