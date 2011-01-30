// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function isEnterKey(e){
  
  var key;      
  if(window.event){
      key = window.event.keyCode; //IE
  }
  else{
      key = e.which; //firefox  
  }    

  return (key == 13);
}

function noEnterKey(e){
  return !isEnter(e);
}


function jsonResource(url, onSuccessFunction){
  options = {
    method: 'get',  
    asynchronous: (onSuccessFunction !== undefined), 
    evalJSON: true,//does not work, because rails does not set content-type 
    requestHeaders: {Accept:'application/json'} 
    }
  if(onSuccessFunction){
    options['onSuccess'] = onSuccessFunction;
  }
  res = new Ajax.Request( url, options);
  result = res.transport.responseText.evalJSON();
  self = Object.keys(result)[0]
  return result[self];
}

function toBase64(input) {
  var keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
  var output = "";
  var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
  var i = 0;

  //input = Base64._utf8_encode(input);

  while (i < input.length) {

    chr1 = input.charCodeAt(i++);
    chr2 = input.charCodeAt(i++);
    chr3 = input.charCodeAt(i++);

    enc1 = chr1 >> 2;
    enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
    enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
    enc4 = chr3 & 63;

    if (isNaN(chr2)) {
      enc3 = enc4 = 64;
    } else if (isNaN(chr3)) {
      enc4 = 64;
    }

    output = output +
    keyStr.charAt(enc1) + keyStr.charAt(enc2) +
    keyStr.charAt(enc3) + keyStr.charAt(enc4);

  }

  return output;
}



//got from http://www.webdeveloper.com/forum/showthread.php?t=187378
function xml2Str(xmlNode) {
   try {
      // Gecko- and Webkit-based browsers (Firefox, Chrome), Opera.
      return (new XMLSerializer()).serializeToString(xmlNode);
  }
  catch (e) {
     try {
        // Internet Explorer.
        return xmlNode.xml;
     }
     catch (e) {  
        //Other browsers without XML Serializer
        alert('Xmlserializer not supported');
     }
   }
   return false;
}



function confirm_dialog(title, question, onOkFunction, onCancelFunction){
  var window;
  var destroyFunction = function(){
    window.close();
    //window.destroy();
  };
  var okWrapper = function(event){
    destroyFunction.apply();
    (onOkFunction || Prototype.K).call(event);
  };
  var cancelWrapper = function(event){
    destroyFunction.apply();
    (onCancelFunction || Prototype.K).call()
  };
  
  var container = NodeBuilder(
    ["div", {title: title}, 
      ["div", {'class': "confirm_question"}, question],
      ["input", {type: "button", 'class': "confirm_button", value: "yes"} ],
      ["input", {type: "button", 'class': "confirm_button", value: "no"}]
    ]
  );
  container.select("input[value='yes']")[0].observe('click', okWrapper);
  container.select("input[value='no']")[0].observe('click', cancelWrapper);
  
  document.body.appendChild(container);
  //var element = NodeBuilder(["div",{title: title}]);
  //document.body.appendChild(element);
  window = window_factory(container, {fade: true});
  //element.down(".window_contents").insert(container)
  
  window.open();
  container.select("input[value='yes']")[0].focus()
}

function parseCSV(str, settings){
  if(!settings){
    settings = {lineSeparator: "\n", recordSeparator: ","}
  }
  var lines = str.split(settings.lineSeparator)
  return lines.map(function(line){
    return line.split(settings.recordSeparator)
  })
}

function spherical2rotation(theta, phi){
  var r_theta = theta*Math.PI/180
  var r_phi = phi*Math.PI/180
  var point = Vector.create([Math.sin(r_theta) * Math.cos(r_phi), Math.sin(r_theta) * Math.sin(r_phi), Math.cos(r_theta)])
  return {
    angle: point.angleFrom(Vector.k),
    direction: point.cross(Vector.k)
  }
}

function spherical2rotationAttribute(theta, phi){
  var rotation = spherical2rotation(theta, phi)
  var result = [];
  rotation.direction.each(function (item, index){
    result.push(item)
  })
  result.push(rotation.angle)
  return result.join(" ")
}

function LL(list){
  if(list.shift !== undefined && list.map !== undefined){
    var f = list.shift();
    f.apply({}, list.map(LL));
  }
  else{
    return list;
  }
}

function NodeBuilder(list){
  
  if(list === undefined){
    throw "NodeBuilder: list is undefined"
  }
  if(typeof list === 'string'){
    return document.createTextNode(list);
  }
  var listSize = list.length;
  if(listSize ==   0){
    throw 'NodeBuidler: list is empty'
  }
  
  var elementName = list[0];
  var attrs;
  if(listSize > 1){
    attrs = list[1];
  }
  var children;
  if(listSize > 2){
    children = list.slice(2);
  }
  var element = document.createElement(elementName);
  if(attrs !== undefined){
    Object.keys(attrs).each(function (k){
      element.setAttribute(k, attrs[k]);
    });
  }
  if(children !== undefined){
    children.each(function(child){
      element.appendChild(NodeBuilder(child));
    });
  }
  return element;
}

function nameFromId(container){
  container.getElements().each(function (e){
    if(e.type != 'radio'){
      e.name = e.id;
    }
  });
}

function toOrdinaryDecimal(number){
  var re = /^(-)?(\d+)((\.)(\d+))?(e(-)?(\d+))?$/.exec(number);
  var full_num = "";
  
  //alert(re);
  if(!re){
    throw "Not a number:" + number
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

function getIndex(string){
  var match = /_(\d+)$/.exec(string)
  if(match === null){
    throw "getIndex(\"" + string + "\") is null"
  } 
  return match[1];
}

function reindexingAttr(attrName, e, index){
  var e_attr = e.readAttribute(attrName);
  if(e_attr){
    e.writeAttribute(attrName, e_attr.replace(/_[^_]+$/, "_" + index));
  }
}

function reindexingId(e, index){
  var e_id = e.readAttribute("id");
  if(e_id){
    e.writeAttribute("id", e_id.replace(/_[^_]+$/, "_" + index));
  }
}

function reindexing(element, index){
  if(element.descendants()){
    element.descendants().each(function(e){
      reindexing(e, index);
    });
  }
  reindexingId(element, index);
  if(element.tagName.toLowerCase() == 'input' && element.type == 'radio'){
    reindexingAttr('name', element, index);
  }
}

function reindexing_selected_children(parentName, selector){
  var i = 0;
  var trs = [];
  $(parentName).select(selector).each(function (e){
    trs.push(e);
  });
  $A(trs).each(reindexing);
}

function translate4human(exp){
  var result = exp;
  dict = [
    { regexp: /&&/g, replacement: "and"},
    { regexp: /<=/g, replacement: "&le;"},
    { regexp: />=/g, replacement: "&ge;"},
    { regexp: /\|\|/g, replacement: "or"},
    { regexp: /==/g, replacement: "="},
    { regexp: /isInteger\(x\)/g, replacement: "integer"},
    { regexp: /isDefined\(x\)/g, replacement: "defined"},
    { regexp: /isNumber\(x\)/g, replacement: "number"},
    { regexp: /divisibleBy(\d+)\(x\)/g, replacement: "divisible by $1"},

     
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
  var result = undefined;
  return (event.which ? String.fromCharCode(event.which) : event.keyCode);//TODO IE
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



//styled examples use the window factory for a shared set of behavior  
var window_factory = function(content,options){  

    var container = NodeBuilder(
      ['div',{},
        ['div', {'class': 'window_header'},
          ['div', {'class': 'window_title'}],
          ['div', {'class': 'window_close'}]
        ]
      ]
    );
    container.appendChild(content);  
    document.body.appendChild(container);
    var w = new Control.Window(container,Object.extend({  
        className: 'window',  
        closeOnClick: container.down("[class='window_close']"),  
        draggable: container.down("[class='window_header']"),  
        //insertRemoteContentAt: window_contents,  
        afterOpen: function(){  
            container.down("[class='window_title']").update(content.readAttribute('title'))  
        }
          
    },options || {}));  
    // w.container.insert({top: window_header});  
    //     window_header.insert(window_title);  
    //     window_header.insert(window_close);  
    //     w.container.insert(window_contents);  
    return w;  
};  