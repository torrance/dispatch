$(function() {
  $('body').removeClass('no-js');

  var publishButton = $('#publish ul');
  $('#publish a.button').toggle(
    function() {
      publishButton.fadeIn('fast');
    },
    function() {
      publishButton.fadeOut('fast');
    }
  );

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