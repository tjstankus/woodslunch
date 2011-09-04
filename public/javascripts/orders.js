function studentOrUserOrders() {
  var re = /users\/(.*)\/orders/;
  if (re.test($(location).attr('href'))) {
    return 'user_orders';
  } else {
    return 'student_orders';
  }
}

$(document).ready(function() {
  $('.menu_item.existing select').change(function() {
    var $container = $(this).parents('.existing');
    if ($(this).val().length == 0) {
      var index = $container.attr('data-index');
      var day = $container.attr('data-day');
      var omiId = $container.attr('data-ordered_menu_item_id');
      var input = '<input name="[' + studentOrUserOrders() + '][' + day +
                 '][ordered_menu_items_attributes][' + index +
                 '][_destroy]" class="destroy" type="hidden" value="1">';
      $container.prepend(input);
    } else {
      $container.find('.destroy').remove();
    }
  });
});
