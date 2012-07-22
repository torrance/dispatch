$(function() {
  $('body').removeClass('no-js');

  /**
   * Control visibility of publish panel
   */
  var publishButton = $('#publish ul');
  $('#publish a.button').click(
    function() {
      publishButton.fadeIn('fast');
    }
  );
  publishButton.mouseleave(function() {
    $(this).fadeOut('slow');
  });
  
  /**
   * Allow users to expand newswire items to view full summary and image.
   */
  $('.newswire-item .collapsed .summary').live('click', function() {
    $(this).parent().removeClass('collapsed');
  });

  /**
   * Hide the pager once it has been clicked
   *
   * We use 'live' to ensure subsequent pagers loaded via ajax also receive the
   * the same treatment.
   */
  $('#pager').live('click', function() {
    $(this).animate({ opacity: 0 }, {
      duration: 'fast',
      complete: function() {
        $(this).css('visibility', 'hidden');
      }
    });
  });
});