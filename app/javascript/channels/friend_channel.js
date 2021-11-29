import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  var notifs = document.getElementById("notifications");

  //const post_id = document.getElementById("post_id").value;
  
  consumer.subscriptions.create({channel: "FriendChannel"}, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log(`works`);
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
      console.log("dc");
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel  
      notifs.classList.add("received");
      
    }
  });
});