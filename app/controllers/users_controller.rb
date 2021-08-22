class UsersController < ApplicationController
  before_action :authenticate_user!
  # method for search form.
  def search

  end
  # finds user profile from params[:name]
  def search_person
    @user = User.find_by(username: params[:name])
    if @user 
      # redirect to user profile here
      redirect_to "/users/#{@user.id}/profile"
    else   
      flash[:bad_search] = "That person does not exist!"
      redirect_to search_users_path
    end

  end

  def friend_request 
    # create the friend request 
    @friend_1 = User.find(params[:friend_1])
    @friend_2 = User.find(params[:friend_2])
    # check if friend request has already been sent 
    @requests = FriendRequest.where(:friend_1 => @friend_1, :friend_2 => @friend_2)
    if @requests.count > 0 
      flash[:already_sent] = "Friend request already sent"
      redirect_to  "/users/#{current_user.id}/profile"
      return
    end
    if @friend_1 == @friend_2 
      flash[:lonely_ass] = "You can't friend yourself."
      redirect_to profile_user_path(current_user.id)
      return 
    end
    # check if friend request has been received from a user 
    @requests = FriendRequest.where(:friend_1 => @friend_2, :friend_2 => @friend_1)
    if @requests.count > 0 
      flash[:already_received] = "Friend request already received"
      redirect_to "/users/#{current_user.id}/profile"
      return
    end
    @friend_request = FriendRequest.create({friend_1_id: @friend_1.id, 
    friend_2_id: @friend_2.id})
    # redirect to profile page 
    if @friend_request.save 
      flash[:request_success] = "Friend request sent!"
    end
    redirect_to "/users/#{current_user.id}/profile"
  end

  def notifications 
    @friend_requests = FriendRequest.where(:friend_2 => current_user)
  end

  def process_request 
    @request = FriendRequest.find(params[:request_id])
    @friend_1 = User.find(@request.friend_1_id)
    @friend_2 = User.find(@request.friend_2_id)
    # making sure you cannot friend yourself under any circumstances
    if params[:accepted] == "true" 
      @friendship = @friend_1.friendships.build({friend: @request.friend_2})
      @friendship.save!
      @friendship = @friend_2.friendships.build({friend: @request.friend_1})
      @request.friend_2.friendships << @friendship
      @request.delete
    else  
      @request.delete
    end 
  end
  # grab all of the users posts
  def profile
    @profile_owner = User.find(params[:id])
    @friends = @profile_owner.friends
    @posts = @profile_owner.posts
  end
  
  def index 

  end
end
