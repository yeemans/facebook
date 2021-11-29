import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const post_id = post_id;
  var bottom = document.getElementById("bottom");

  //const post_id = document.getElementById("post_id").value;
  
  consumer.subscriptions.create({channel: "PostChannel", post_id: post_id}, {
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
      bottom.innerHTML += '<a href ="/posts/"> See New Posts </a>';
      
    }
  });
});