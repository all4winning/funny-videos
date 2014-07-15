$("#notifications").click(function(e){
  e.preventDefault();
  $("#notifications span").addClass("hidden");
  if ($("#notifications_box li").length < 1) {
    $.ajax({
      type: 'GET',
      url: "/users/user/notifications",
      // dataType: 'html',
      success: function(html){
        $("#notifications_box").append(html);
      }
    });
  }
})