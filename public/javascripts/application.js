// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function toOrdinaryDecimal(number){
  var re = /^(-)?(\d+)((\.)(\d+))?(e(-)?(\d+))?$/.exec(number);
  var full_num = "";
  
  //alert(re);
  if(!re){
    throw {name: "NaN", message: "Not a number:" + number}
  }
  

  var exponent = re[6] ? re[6].slice(1) : 0;
  var dot_pos = re[2].length + Number(exponent);
  var fraction = re[5] ? re[5] : "";
  var integer_part = "";
  if(/^0+$/.match(re[2]) && fraction.length > 0){
    integer_part = "";
    dot_pos --;
  }
  else{
    integer_part = re[2];
  }
  full_num += integer_part + fraction;
  if(dot_pos <= 0){
    var i = dot_pos;
    var zeros = "";
    while(i++<0){
      zeros += "0";
    }
    full_num = "0." + zeros + full_num;
  }
  else{
    if(dot_pos < full_num.length){
      full_num = full_num.slice(0, dot_pos) + "." + full_num.slice(dot_pos);
    }
    else{
      var i = dot_pos - full_num.length;
      while(i-->0){
        full_num += "0";
      }
    }
  }
  if(re[1]){
    full_num = "-" + full_num;
  }
  return full_num ;//+ "|" + " => " + re;  
}



function reindexing(element, index){
  element.descendants().each(function(e){
    var e_id = e.readAttribute("id");
    if(e_id){
      e.writeAttribute("id", e_id.replace(/\d+$/, index));
    }
  });
  var element_id = element.readAttribute("id");
  if(element_id){
    element.writeAttribute("id", element_id.replace(/\d+$/, index));
  }
}

function translate4human(exp){
  var result = exp;
  dict = [
    { regexp: /&&/g, replacement: "and"},
    { regexp: /<=/g, replacement: "&le;"},
    { regexp: /\|\|/g, replacement: "or"},
    { regexp: /==/g, replacement: "="},
    { regexp: /isInteger\(x\)/g, replacement: "integer"},
    { regexp: /isDefined\(x\)/g, replacement: "defined"},

     
    ];
  dict.each(function (dict_element){
    result = result.replace(dict_element.regexp, dict_element.replacement);
  });
  return result;
}

function isNumber(num){
  return num !== "" && isFinite(num);
}

function  divisibleBy4(num){
  divisibleBy(num, 4);
}

function divisibleBy(num, divider){
  return num % divider == 0
}

function isDefined(val){
  if(val === "" || val === null || val === undefined){
    throw {name: 'notDefined'}
  }
  return true;
}

function isInteger(n){
  return n == Math.floor(n);
}

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