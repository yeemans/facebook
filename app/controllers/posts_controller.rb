class PostsController < ApplicationController
  before_action :authenticate_user!
  def index 
    @posts = current_user.posts 
    @recent_posts = @posts.last(3).reverse
    @friends = current_user.friends 
    # get friends' posts 
    @friends_posts = []
    @friends.each do |friend|
      friend.posts.each do |post| 
        @friends_posts.push(post)
      end
    end
    @friends_posts = @friends_posts.reverse
    @default = "https://www.online-tech-tips.com/wp-content/uploads/2019/09/discord.jpg"
  end
  
  def new 
    @post = Post.new
  end

  def create 
    @post = current_user.posts.build({ body: params[:post][:body] })
    @post.save!
    if @post.save 
      flash[:post_success] = "Post successfully created!" 
      redirect_to posts_path # timeline
    end
  end

  def show 
    
  end

  def like 
    @post = Post.find(params[:id])
    # check if user has already liked post
    if @post.liking_users.include?(current_user)
      # remove the like 
      current_user.liked_posts.delete(@post)
      flash[:like_message] = "Post unliked :(."
    else  
      current_user.liked_posts << @post
      flash[:like_message] = "Post liked."
    end
      redirect_to posts_path
  end
end
