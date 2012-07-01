$(function() {
  $(".markitup").markItUp({
    previewParserPath:  '',
    onShiftEnter:   {keepDefault:false, openWith:'\n\n'},
    afterInsert: function() { $(".markitup").keyup(); },
    markupSet: [
      {name:'Subheading', key:'2', openWith:'## ', placeHolder:'Your title here...' },
      {name:'Sub-subheading', key:'3', openWith:'### ', placeHolder:'Your title here...' },
      {separator:'---------------' },   
      {name:'Bold', key:'B', openWith:'**', closeWith:'**'},
      {name:'Italic', key:'I', openWith:'_', closeWith:'_'},
      {separator:'---------------' },
      {name:'Bulleted List', openWith:'- ' },
      {name:'Numeric List', openWith:function(markItUp) {
        return markItUp.line+'. ';
      }},
      {separator:'---------------' },
      {name:'Link', key:'L', openWith:'[', closeWith:']([![Url:!:http://]!] "[![Title]!]")', placeHolder:'Your text to link here...' },
      {separator:'---------------'},  
      {name:'Blockquote', openWith:'> '},
    ]
  });
});