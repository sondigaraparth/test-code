class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[edit update destroy]

  def index
    @posts = current_user.posts.order(created_at: :desc)
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path, notice: "Post created." }
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path, notice: "Post not created." }
      end
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to posts_path, notice: "Post updated." }
      end
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path, notice: "Post deleted." }
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :content)
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end
