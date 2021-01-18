$(document).on("shiny:sessioninitialized", function(event) {
  
  "use strict";
  
  // about section handler
  Shiny.addCustomMessageHandler("aboutSectionHandler", function(message) {
      if (message == "show") {
        $("#about").show();  
         
      } else if (message == "hide") {
        $("#about").hide();  
      }
  });
  
  // screen width
  Shiny.setInputValue("screen_width", window.innerWidth);
  
  $(window).on("resize", function() { 
    Shiny.setInputValue("screen_width", window.innerWidth);
  });
  
  // licenses tooltip

	$("#licenses > span").hover(
		function() { $("#licenses > div").fadeIn(); },
		function() { $("#licenses > div").fadeOut(); }
	);
  
});
