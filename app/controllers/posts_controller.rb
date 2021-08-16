class PostsController < ApplicationController
  before_action :authenticate_user!
  def index 
    @posts = current_user.posts 
    @recent_posts = [@posts.last, @posts[@posts.count - 2], 
    @posts[@posts.count - 3]]
    @friends = current_user.friends 
    # get friends' posts 
    @friends_posts = []
    @friends.each do |friend|
      friend.posts.each do |post| 
        @friends_posts.push(post)
      end
    end
  end
  
  def new 

  end

  def create 
    @post = current_user.posts.build({ body: params[:body] })
    @post.save!
    if @post.save 
      flash[:post_success] = "Post successfully created!" 
      redirect_to "" # timeline
    end
  end

  def show 
    
  end
end
