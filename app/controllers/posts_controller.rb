class PostsController < ApplicationController
  before_action :authenticate_user!
  def index 
    @post = Post.new
    @posts = current_user.posts 
    # get last 3 posts from the user
    @recent_posts = @posts.last(3).reverse
    @friends = current_user.friends 
    # get friends' posts 
    @friends_posts = []
    @friends.each do |friend|
      friend.posts.each do |post| 
        @friends_posts.push(post)
      end
    end
    # reverse the posts to put the most recent ones on top
    @friends_posts = @friends_posts.reverse
   
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
    # broadcast the message to users' friends
    gon.post_id = @post.id
    p "GON: #{gon.post_id}"
    current_user.friends.each do |friend|
      ActionCable.server.broadcast("post_channel_#{friend.id}", post_id: @post.id)
      p "Friend id: #{friend.id}"
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
      # send a notification to owner of post 
      @owner = @post.user
      @text = " liked your post."
      Notification.create({text: @text, notifier: current_user, receiver: @owner, 
        action: "like"})
    end
      redirect_to posts_path
  end
end