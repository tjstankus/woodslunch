$(document).ready(function() {
  $('a#pay_cash_check_link').click(function(event) {
    event.preventDefault();
    $('#pay_cash_check_instructions').slideToggle();
  });
});
