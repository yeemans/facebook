class CommentsController < ApplicationController
  def index 

  end 

  def new 
    @post = Post.find(params[:id])
    @comment = Comment.new
  end 

  def show 

  end 

  def create 
    @post = Post.find(params[:comment][:post])
    @comment = @post.comments.build({body: params[:comment][:body]})
    @comment.user_id = @post.user_id
    @comment.save!
    if @comment.save 
      redirect_to new_comment_path
    end
    # create the notification 
    text = " commented on your post: '#{@comment.body}'"
    Notification.create({text: text, notifier: current_user, receiver: @post.user, 
      action: "comment"})
  end 

  def edit 

  end 

  def update 

  end 

  def delete 

  end
end
