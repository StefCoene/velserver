// Toggle functie START

// Hiermee kan je een element van een pagina verbergen door het de class toggle te geven.
// Dan wordt het element verborgen en het bovenliggende element krijgt dan een Show/Hide knop

// class topggl1: data wordt verborgen, + Show knop om te laten ziwn
// class toggle2: Hide knop om iets te verbergen

// gebaseerd op http://andylangton.co.uk/articles/javascript/jquery-show-hide-multiple-elements/

$(document).ready(function() {
   // choose text for the show/hide link - can contain HTML (e.g. an image)
   var showText = "<img src=include/icons/show.png />" ;
   var hideText = "<img src=include/icons/hide.png />" ;

   // initialise the visibility check
   var is_visible1 = false;

   // append show/hide links to the element directly preceding the element with a class of "toggle1"
   $(".toggle1").prev().append(" <a href=\"#\" class=\"toggle1Link\">"+showText+"</a>") ;

   // hide all of the elements with a class of "toggle1"
   $(".toggle1").hide() ;

   // capture clicks on the toggle links
   $("a.toggle1Link").click(function() {
      // switch visibility
      is_visible1 = !is_visible1 ;

      // change the link depending on whether the element is shown or hidden
      $(this).html( (!is_visible1) ? showText : hideText) ;

      // toggle the display - uncomment the next line for a basic "accordion" style
      //$(".toggle1").hide();$("a.toggle1Link").html(showText);
      $(this).parent().next(".toggle1").toggle("slow") ;

      // return false so any link destination is not followed
      return false ;
   });

   // initialise the visibility check
   var is_visible2 = true;

   // append show/hide links to the element directly preceding the element with a class of "toggle2"
   $(".toggle2").prev().append(" <a href=\"#\" class=\"toggle2Link\">"+hideText+"</a>") ;

   // capture clicks on the toggle links
   $("a.toggle2Link").click(function() {
      // switch visibility
      is_visible2 = !is_visible2 ;

      // change the link depending on whether the element is shown or hidden
      $(this).html( (!is_visible2) ? showText : hideText) ;

      // toggle the display - uncomment the next line for a basic "accordion" style
      //$(".toggle2").hide();$("a.toggle2Link").html(showText);
      $(this).parent().next(".toggle2").toggle("slow") ;

      // return false so any link destination is not followed
      return false ;
   });

});
// Toggle functie END
