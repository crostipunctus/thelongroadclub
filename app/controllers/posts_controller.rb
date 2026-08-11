class PostsController < ApplicationController
  before_action :require_authentication
  before_action :set_post, only: %i[update destroy]
  before_action :authorize_post, only: %i[update destroy]

  def create
    discussion = Discussion.find_by!(slug: params[:discussion_slug])
    return render_forbidden if discussion.locked? || discussion.archived?

    post = discussion.posts.new(body: post_params[:body], user: current_user)
    post.parent = discussion.posts.find(post_params[:parent_id]) if post_params[:parent_id].present?
    if post.save
      respond_to do |format|
        format.html { redirect_to discussion_path(discussion, anchor: "post-#{post.id}"), notice: "Reply posted." }
        format.json { render json: { id: post.id, body: post.body, parent_id: post.parent_id, depth: post.depth, created_at: post.created_at }, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to discussion, alert: post.errors.full_messages.to_sentence }
        format.json { render json: { errors: post.errors.to_hash }, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @post.update(body: post_params[:body], edited_at: Time.current)
      redirect_to discussion_path(@post.discussion, anchor: "post-#{@post.id}"), notice: "Reply updated."
    else
      redirect_to @post.discussion, alert: @post.errors.full_messages.to_sentence
    end
  end

  def destroy
    discussion = @post.discussion
    @post.destroy!
    redirect_to discussion, notice: "Reply removed."
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_post
    render_forbidden unless @post.editable_by?(current_user)
  end

  def post_params
    params.require(:post).permit(:body, :parent_id)
  end
end
