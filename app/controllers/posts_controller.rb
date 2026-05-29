class PostsController < ApplicationController
  def index
    @posts = Post.published.recent_first
  end

  def show
    @post = Post.published.find(params[:id])
  end
end
