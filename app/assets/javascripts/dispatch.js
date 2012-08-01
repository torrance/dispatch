$(function() {
  /**
   * Allow us to target users with and without javascript using CSS.
   */
  $('body').removeClass('no-js').addClass('has-js');

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
    $(this).parent().addClass('expanded').removeClass('collapsed');
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

  /**
   * Colorbox
   */
  $('.image-gallery a.image').colorbox({
    rel: 'image',
    transition: 'none',
    maxHeight: '90%',
    maxWidth: '90%'
  });

  $('#show-all-images').click(function(e) {
    $('.image-gallery a.image').first().click();
    e.preventDefault();
  });
});