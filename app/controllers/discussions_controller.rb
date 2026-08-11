class DiscussionsController < ApplicationController
  before_action :require_authentication, except: %i[index show]
  before_action :set_discussion, only: %i[show edit update destroy]
  before_action :authorize_discussion, only: %i[edit update destroy]

  def index
    @categories = Category.all
    @discussions = Discussion.fresh.includes(:category, :user)
    @discussions = @discussions.where(category: Category.find_by!(slug: params[:category])) if params[:category].present?
    if params[:q].present?
      query = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q].strip)}%"
      @discussions = @discussions.where("discussions.title LIKE :q OR discussions.body LIKE :q", q: query)
    end

    respond_to do |format|
      format.html
      format.json { render json: @discussions.limit(50).map { |discussion| discussion_json(discussion) } }
    end
  end

  def show
    @discussion.record_view! unless current_user == @discussion.user
    @posts = @discussion.posts.includes(:user).order(:created_at)
    @posts_by_parent = @posts.group_by(&:parent_id)
    @post = Post.new
    @bookmarked = current_user&.bookmarks&.exists?(discussion: @discussion) || false

    respond_to do |format|
      format.html
      format.json { render json: discussion_json(@discussion).merge(body: @discussion.body, posts: @posts.map { |post| post_json(post) }) }
    end
  end

  def new
    @discussion = current_user.discussions.new
    @categories = Category.all
  end

  def create
    @discussion = current_user.discussions.new(discussion_params)
    if @discussion.save
      respond_to do |format|
        format.html { redirect_to @discussion, notice: "Discussion started." }
        format.json { render json: discussion_json(@discussion), status: :created }
      end
    else
      @categories = Category.all
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @discussion.errors.to_hash }, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @categories = Category.all
  end

  def update
    if @discussion.update(discussion_params)
      redirect_to @discussion, notice: "Discussion updated."
    else
      @categories = Category.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @discussion.destroy!
    redirect_to discussions_path, notice: "Discussion removed."
  end

  private

  def set_discussion
    @discussion = Discussion.includes(:category, :user).find_by!(slug: params[:slug])
  end

  def authorize_discussion
    render_forbidden unless @discussion.editable_by?(current_user)
  end

  def discussion_params
    params.require(:discussion).permit(:title, :body, :category_id)
  end

  def discussion_json(discussion)
    {
      id: discussion.id, slug: discussion.slug, title: discussion.title,
      excerpt: discussion.excerpt, status: discussion.status,
      replies_count: discussion.replies_count, views_count: discussion.views_count,
      category: { name: discussion.category.name, slug: discussion.category.slug },
      author: { name: discussion.user.name, username: discussion.user.username },
      last_posted_at: discussion.last_posted_at
    }
  end

  def post_json(post)
    { id: post.id, body: post.body, parent_id: post.parent_id, depth: post.depth, author: { name: post.user.name, username: post.user.username }, created_at: post.created_at, edited_at: post.edited_at }
  end
end
