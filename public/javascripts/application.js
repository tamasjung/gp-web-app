// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function whichKey(event){
  
  return (event.which ? String.fromCharCode(event.which) : null);//TODO IE
}

function radio_value(group_name){
  var result = null;
  $$('input[type=radio][name=' + group_name + ']').each(function(r){
    if(r.checked){
      result = r.value;
    }
  });
  return result;
}

function builder(container_id){
  $(container_id);
}
function text_field(name, type_obj){
  return new Element('a', { 'class': 'foo', href: '/foo.html' }).update("heheheheheh");
} 

//styled examples use the window factory for a shared set of behavior  
var window_factory = function(container,options){  
    var window_header = new Element('div',{  
        className: 'window_header'  
    });  
    var window_title = new Element('div',{  
        className: 'window_title'  
    });  
    var window_close = new Element('div',{  
        className: 'window_close'  
    });  
    var window_contents = new Element('div',{  
        className: 'window_contents'  
    });  
    var w = new Control.Window(container,Object.extend({  
        className: 'window',  
        closeOnClick: window_close,  
        draggable: window_header,  
        //insertRemoteContentAt: window_contents,  
        afterOpen: function(){  
            window_title.update(container.readAttribute('title'))  
        }
          
    },options || {}));  
    w.container.insert(window_header);  
    window_header.insert(window_title);  
    window_header.insert(window_close);  
    w.container.insert(window_contents);  
    return w;  
};  