class PostChannel < ApplicationCable::Channel
  def subscribed
    # stream from friends' channels 
    stream_from "post_channel_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
