//= require jquery-ui
//= require jquery.markitup
//= require markitup

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
  function split( val ) {
    return val.split( /,\s*/ );
  }

  function extractLast( term ) {
    return split( term ).pop();
  }

  $('form.content .tags input')
  // don't navigate away from the field on tab when selecting an item
  .bind( "keydown", function( event ) {
    if ( event.keyCode === $.ui.keyCode.TAB &&
        $( this ).data( "autocomplete" ).menu.active ) {
      event.preventDefault();
    }
  })
  .autocomplete({
    source: function( request, response ) {
      $.getJSON( "/tags", {
        q: extractLast( request.term )
      }, response );
    },
    search: function() {
      // custom minLength
      var term = extractLast( this.value );
      if ( term.length < 2 ) {
        return false;
      }
    },
    focus: function() {
      // prevent value inserted on focus
      return false;
    },
    select: function( event, ui ) {
      var terms = split( this.value );
      // remove the current input
      terms.pop();
      // add the selected item
      terms.push( ui.item.value );
      // add placeholder to get the comma-and-space at the end
      terms.push( "" );
      this.value = terms.join( ", " );
      return false;
    }
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