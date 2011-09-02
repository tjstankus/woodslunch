$(document).ready(function() {

  /* nav menu */
  $('ul.dropdown li').hover(function() {
      $('ul:first', this).css('visibility', 'visible');
    }, function() {
      $('ul:first', this).css('visibility', 'hidden');
  });

  /* disable submit buttons onclick */
  $('form').submit(function() {
    $('input[type=submit]', this).attr('disabled', 'disabled');
  });
});
