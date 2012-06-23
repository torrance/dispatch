$(function() {
  // Allow images to be ordered. When they are dragged, we reassign values to
  // a hidden weight field.
  $('.sortable').sortable({
    handle: '.handle',
    update: function() {
      $('.sortable').children().each(function(index, element) {
        $('.image-weight', element).val(index);
      });
    }
  });
});