$(document).ready(function() {
  $('input#date').datepicker({
    dateFormat: 'yy-mm-dd',
    onSelect: function(dateText, inst) {
      $('form input[type=submit]').show();
    }
  });
});
