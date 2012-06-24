window.DISPATCH = window.DISPATCH || {};

/**
 * Content edit forms
 */
DISPATCH.reweight = function() {
  $('.sortable').children().each(function(index, element) {
    $('.image-weight', element).val(index);
  });
};

DISPATCH.add_fields = function(association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  var content = content.replace(regexp, new_id);
  $('#add-' + association + '-field-to').append(content);

  DISPATCH.reweight();
}

$(function() {
  // Allow images to be ordered. When they are dragged, we reassign values to
  // a hidden weight field.
  $('.sortable').sortable({
    handle: '.handle',
    update: DISPATCH.reweight
  });
});

/**
 * Image galleries
 */
$('.image-slider').cycle();