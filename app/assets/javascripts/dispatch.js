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

  /**
   * 'Social' media buttons
   */
  var facebookInit = function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
    fjs.parentNode.insertBefore(js, fjs);
  };

  window.___gcfg = {lang: 'en-GB'};
  var googleInit = function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/plusone.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  };

  var twitterInit = function(d,s,id) {
    var js,fjs=d.getElementsByTagName(s)[0];
    if (!d.getElementById(id)) {
      js=d.createElement(s);
      js.id=id;
      js.src="//platform.twitter.com/widgets.js";
      fjs.parentNode.insertBefore(js,fjs);
    }
  };

  $('img.social-media-buttons').click(function() {
    $(this).fadeOut();
    $('#social-media-tooltip').fadeOut().remove();
    facebookInit(document, 'script', 'facebook-jssdk');
    googleInit();
    twitterInit(document, "script", "twitter-wjs");
  });

  $('img.social-media-buttons').hover(function() {
    $('#social-media-tooltip').fadeIn(200);
  });

  $('img.social-media-buttons').mouseleave(function() {
     $('#social-media-tooltip').fadeOut(200);
  });

  $(document).bind('mousemove', function(e) {
    $('#social-media-tooltip').css({
      left: e.pageX + 20,
      top: e.pageY
    });
  });
});