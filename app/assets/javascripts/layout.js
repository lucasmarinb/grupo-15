$(document).on('turbolinks:load', function() {

  // Close the dropdown menu if the user clicks outside of it
  var btn = $(".dropbtn-profile");
  var dropdown = $("#user-dropdown")
  dropdownToggle(btn, dropdown);
  var btn2 = $(".dropbtn-explore");
  var dropdown2 = $("#explore-dropdown")
  dropdownToggle(btn2, dropdown2);

  $(".search-icon").click(function(){
    var form_input = $("#search-form input");
    form_input.attr("placeholder", "");
    form_input.val('');
    form_input.animate({width:'toggle'}, function(){
      form_input.focus();
    });
  });

  $("#notice").css("left", ($(window).width()-$("#notice").width())/2)
  $("#alert-container").css("left", ($(window).width()-$("#alert-container").width())/2)

});

var dropdownToggle = function(btn, dropdown) {
  btn.click(function(e){
    dropdown.toggleClass("block");
  });

  $(window).click (function(event) {
      if (dropdown.css("display")==="block"&&event.target != dropdown[0] && $(event.target).closest(".dropbtn")[0]!==btn[0]) {
        dropdown.toggleClass("block");
      }
  });
}
