$(document).ready(function() {

  $('ul.dropdown li').hover(function() {

      $('ul:first', this).css('visibility', 'visible');

    }, function() {

      $('ul:first', this).css('visibility', 'hidden');

  });
});
