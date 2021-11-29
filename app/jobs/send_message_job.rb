class SendMessageJob < ApplicationJob
  queue_as :default

  def perform(message)
    # queue the sending of messages
    html = "<p>#{message.sender.username}: #{message.text}</p>"
    # unique identifier for each conversation between users 
    chat_id = [message.sender.id, message.receiver.id].sort.join("")
    ActionCable.server.broadcast("message_channel_#{chat_id}",html: html)
  end
end
