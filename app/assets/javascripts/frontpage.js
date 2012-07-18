$(function() {
  $('.newswire-item .collapsed .summary').live('click', function() {
    $(this).parent().removeClass('collapsed');
  });

  // Hide the pager once it has been clicked.
  $('#pager').live('click', function() {
    $(this).animate({ opacity: 0 }, {
      duration: 'fast',
      complete: function() {
        $(this).css('visibility', 'hidden');
      }
    });
  });
});