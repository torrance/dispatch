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
 * Colorbox
 */
$(function() {
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

/**
 * Add datepicker to all input fields with 'datepicker' class.
 */
$(function() {
  var year = $('#event_start_1i');
  var month = $('#event_start_2i');
  var day = $('#event_start_3i');

  var updateSelected = function(dates) {
    console.log(dates);
    var date = dates.split(' ');
    console.log(date);
    year.val(parseInt(date[0], 10));
    month.val(parseInt(date[1], 10));
    day.val(parseInt(date[2], 10));
  }

  var updateDatepicker = function() {
    $('.datepicker').datepicker('setDate', new Date(year.val(), month.val() - 1, day.val()));
  }

  // Set up the datepicker
  $('.datepicker').datepicker({
    showOn: 'button',
    buttonImage: '/assets/calendar.png',
    buttonImageOnly: true,
    onSelect: updateSelected,
    dateFormat: "yy mm dd",
  });
  updateDatepicker();

  year.change(updateDatepicker);
  month.change(updateDatepicker);
  day.change(updateDatepicker);
  
});

/**
 * Tagging autocomplete
 */
$(function() {
  $('form.content .tags input').tokenInput('/tags.json', {
    crossDomain: false,
    prePopulate: $('form.content .tags input').data('tags'),
    tokenLimit: 5,
    preventDuplicates: true
  });
});


/**
 * Live preview
 */
$(function() {
  var textarea = $('form.content textarea.markitup');
  var preview = $('form.content #live-preview .html');
  var initialized = false;

  var getHtml = function(text, callback) {
    $.post('/content-filter/markdown.json', { 'text': text }, function(data) {
      callback(data.html);
    });
  };

  var setHtml = function(html) {
    preview.html(html);
    preview.scrollTop(preview[0].scrollHeight);
  };

  // Stolen from http://stackoverflow.com/questions/2219924/
  var typewatch = (function(){
    var timer = 0;
    return function(callback, ms){
      clearTimeout (timer);
      timer = setTimeout(callback, ms);
    }  
  })();

  textarea.keyup(function() {
    typewatch(function() {
      if (!initialized) {
        $('form.content #live-preview').slideDown('fast');
        initialized = true;
      }

      text = textarea.val();
      if (text == '') {
        $('form.content #live-preview').slideUp('fast');
        initialized = false;
      }
      
      getHtml(text, setHtml);
    }, 400);
  });
})