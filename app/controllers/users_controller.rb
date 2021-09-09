class UsersController < ApplicationController
  before_action :authenticate_user!
  def index 
    # get every user except for the logged in one
    @users = User.where.not(id: current_user.id)
    # do not show users with pending requests involving current user
    @requests = FriendRequest.where(friend_1: current_user.id).or( 
    FriendRequest.where(friend_2_id: current_user.id))
    # return users in @requests 
    @pending_users = []
    @requests.each do |request| 
      @pending_users.push(User.find(request.friend_1_id))
      @pending_users.push(User.find(request.friend_2_id))
    end
    # do not show user's friends 
    @friends = current_user.friends
  end
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
    if @profile_owner.profile_picture
      @pfp = @profile_owner.profile_picture
    else  
      default = "https://www.online-tech-tips.com/wp-content/uploads/2019/09/discord.jpg"
      @pfp = default 
    end
  end

  def pfp_url  
    
  end

  def change_pfp 
    current_user.profile_picture = params[:url]
    current_user.save!
    redirect_to profile_user_path
  end
end
