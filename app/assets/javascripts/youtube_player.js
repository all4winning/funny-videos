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
		   'onStateChange': onPlayerStateChange
	      },
	  loop: 1,
	  });
}
  // 5. The API calls this function when the player's state changes.
  //    The function indicates that when playing a video (state=1),
  //    the player should play for six seconds and then stop.
  // when video ends
function onPlayerStateChange(event) {        
    if(event.data === 0) {   
    	var imageUrl = $("#player").data("image");
		$(".video-container").css({'background-image': 'url(' + imageUrl + ')',
					'background-repeat': 'no-repeat',
					'background-position': 'center',
					'background-size': 'cover'});
		$("iframe").hide();
		$(".videomessage").show();
		$(".video-facebook_connect").hide();
		
		$(".replay").on("click", function(){
			$("iframe").show();
		    $(".videomessage").hide();
		    $(".video-facebook_connect").show();
		    event.target.playVideo();
		});
		$.ajax({
		    type: "POST",
		    url: "/posts/videos/video_counter",
		    cache: false,
		});
		$(".fclick").on("click", function(event){
			//event.preventDefault();
			$.ajax({
		    type: "POST",
		    url: "/posts/videos/clicks",
					        cache: false,
					    });
					   });
		            }
		        };