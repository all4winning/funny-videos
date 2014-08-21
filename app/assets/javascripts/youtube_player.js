// 2. This code loads the IFrame Player API code asynchronously.
      var tag = document.createElement('script');

      tag.src = "https://www.youtube.com/iframe_api";
      var firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

      // 3. This function creates an <iframe> (and YouTube player)
      //    after the API code downloads.
      var player;
      function onYouTubeIframeAPIReady() {
      	var id = $("#player").data("id");
        player = new YT.Player('player', {
          height: '390',
          width: '640',
          videoId: id,
          events: {
            //'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange
          }
        });
      }

      // 4. The API will call this function when the video player is ready.
      function onPlayerReady(event) {
        event.target.playVideo();
      }

      // 5. The API calls this function when the player's state changes.
      //    The function indicates that when playing a video (state=1),
      //    the player should play for six seconds and then stop.
      var done = false;
      // when video ends
        function onPlayerStateChange(event) {        
            if(event.data === 0) {          
                $("iframe").hide();
                $(".videomessage").show();
                $(".video-facebook_connect").hide();
                
                
                $.ajax({
			        type: "POST",
			        url: "/posts/videos/video_counter",
			        cache: false,
			        success: function(data) {
			        	console.log("succ");
			          }
			    });
			    
			    $(".fclick").on("click", function(){
			    	$.ajax({
			        type: "POST",
			        url: "/posts/videos/clicks",
			        cache: false,
			        success: function(data) {
			        	console.log("succ");
			          }
			    });
			   });
            }
        }
  //    function stopVideo() {
  //      player.stopVideo();
  //    }