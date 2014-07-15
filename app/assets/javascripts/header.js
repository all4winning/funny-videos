$("#notifications .dropdown-toggle").click(function(e){
  e.preventDefault();
  $("#notifications .dropdown-toggle span").addClass("hidden");
  if ($("#notifications_box li").length < 1) {
    $.ajax({
      type: 'GET',
      url: "/users/user/notifications",
      success: function(html){
        $("#notifications_box").append(html);
      }
    });
  }
})