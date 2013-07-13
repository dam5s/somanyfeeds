
(function(doc){var html=doc.documentElement,conf={screens:[320,480,640,768,1024,1280,1440,1680,1920],section:"-section",page:"-page",head:"head"},klass=[];if(window.head_conf){for(var key in head_conf){if(head_conf[key]){conf[key]=head_conf[key];}}}
function pushClass(name){klass.push(name);}
function removeClass(name){var re=new RegExp("\\b"+name+"\\b");html.className=html.className.replace(re,'');}
function each(arr,fn){for(var i=0;i<arr.length;i++){fn.call(arr,arr[i],i);}}
var api=window[conf.head]=function(){api.ready.apply(null,arguments);};api.feature=function(key,enabled,queue){if(!key){html.className+=' '+klass.join(' ');klass=[];return;}
if(Object.prototype.toString.call(enabled)=='[object Function]'){enabled=enabled.call();}
pushClass((enabled?'':'no-')+key);api[key]=!!enabled;if(!queue){removeClass('no-'+key);removeClass(key);api.feature();}
return api;};var ua=navigator.userAgent.toLowerCase();ua=/(webkit)[ \/]([\w.]+)/.exec(ua)||/(opera)(?:.*version)?[ \/]([\w.]+)/.exec(ua)||/(msie) ([\w.]+)/.exec(ua)||!/compatible/.test(ua)&&/(mozilla)(?:.*? rv:([\w.]+))?/.exec(ua)||[];if(ua[1]=='msie'){ua[1]='ie';}
pushClass(ua[1]);api.browser={version:ua[2]};api.browser[ua[1]]=true;if(api.browser.ie){for(var ver=3;ver<11;ver++){if(parseFloat(ua[2])<ver){pushClass("lt-ie"+ver);}}}
each("abbr|article|aside|audio|canvas|details|figcaption|figure|footer|header|hgroup|mark|meter|nav|output|progress|section|summary|time|video".split("|"),function(el){doc.createElement(el);});each(location.pathname.split("/"),function(el,i){if(this.length>2&&this[i+1]!==undefined){if(i){pushClass(this.slice(1,i+1).join("-")+conf.section);}}else{var id=el||"index",index=id.indexOf(".");if(index>0){id=id.substring(0,index);}
html.id=id+conf.page;if(!i){pushClass("root"+conf.section);}}});function screenSize(){var w=window.outerWidth||html.clientWidth;html.className=html.className.replace(/ (w|lt)-\d+/g,"");pushClass("w-"+Math.round(w/100)*100);each(conf.screens,function(width){if(w<=width){pushClass("lt-"+width);}});api.feature();}
screenSize();window.onresize=screenSize;api.feature("js",true).feature();})(document);(function(){var el=document.createElement("i"),style=el.style,prefs=' -o- -moz- -ms- -webkit- -khtml- '.split(' '),head_var=window.head_conf&&head_conf.head||"head",api=window[head_var];function testAll(definition){style.cssText=prefs.join(definition+";");var val=style.cssText;if(val.indexOf("-o")!=-1&&val.indexOf("-ms")!=-1){return false;}
return!!val;}
var tests={gradient:function(){var s1='background-image:',s2='gradient(linear,left top,right bottom,from(#9f9),to(#fff));',s3='linear-gradient(left top,#eee,#fff);';style.cssText=(s1+prefs.join(s2+s1)+prefs.join(s3+s1)).slice(0,-s1.length);return!!style.backgroundImage;},rgba:function(){style.cssText="background-color:rgba(0,0,0,0.5)";return!!style.backgroundColor;},boxshadow:function(){return testAll("box-shadow: 0 0 0 red");},textshadow:function(){return style.textShadow==='';},multiplebgs:function(){style.cssText="background:url(//:),url(//:),red url(//:)";return new RegExp("(url\\s*\\(.*?){3}").test(style.background);},borderimage:function(){return testAll("border-image: url(m.png) 1 1 stretch");},borderradius:function(){return testAll('border-radius:0');},opacity:function(){return el.style.opacity==="";},reflections:function(){return testAll("box-reflect:right 0");},transforms:function(){return testAll("transform:rotate(1deg)");},transitions:function(){return testAll("transition:all .1s linear");}};for(var key in tests){if(tests[key]){api.feature(key,tests[key].call(),true);}}
api.feature();})();(function(doc){var head=doc.documentElement,ie=navigator.userAgent.toLowerCase().indexOf("msie")!=-1,ready=false,queue=[],handlers={},scripts={};var head_var=window.head_conf&&head_conf.head||"head",api=window[head_var]=(window[head_var]||function(){api.ready.apply(null,arguments);});api.js=function(){var args=arguments,rest=[].slice.call(args,1),next=rest[0];if(!ready){queue.push(function(){api.js.apply(null,args);});return api;}
if(next){if(!isFunc(next)){each(rest,function(el){if(!isFunc(el)){preload(getScript(el));}});}
load(getScript(args[0]),isFunc(next)?next:function(){api.js.apply(null,rest);});}else{load(getScript(args[0]));}
return api;};api.ready=function(key,fn){var script=scripts[key];if(script&&script.state=='loaded'){fn.call();return api;}
if(isFunc(key)){fn=key;key="ALL";}
var arr=handlers[key];if(!arr){arr=handlers[key]=[fn];}
else{arr.push(fn);}
return api;};function toLabel(url){var els=url.split("/"),name=els[els.length-1],i=name.indexOf("?");return i!=-1?name.substring(0,i):name;}
function getScript(url){var script;if(typeof url=='object'){for(var key in url){if(url[key]){script={name:key,url:url[key]};}}}else{script={name:toLabel(url),url:url};}
var existing=scripts[script.name];if(existing){return existing;}
scripts[script.name]=script;return script;}
function each(arr,fn){if(!arr){return;}
if(typeof arr=='object'){arr=[].slice.call(arr);}
for(var i=0;i<arr.length;i++){fn.call(arr,arr[i],i);}}
function isFunc(el){return Object.prototype.toString.call(el)=='[object Function]';}
function onPreload(script){script.state="preloaded";each(script.onpreload,function(el){el.call();});}
function preload(script,callback){if(!script.state){script.state="preloading";script.onpreload=[];if(/Firefox/.test(navigator.userAgent)){var obj=doc.createElement('object');obj.data=script.url;obj.width=0;obj.height=0;obj.onload=function(){onPreload(script);setTimeout(function(){head.removeChild(obj);},1);};head.appendChild(obj);}else{scriptTag({src:script.url,type:'cache'},function(){onPreload(script);});}}}
function load(script,callback){if(script.state=='loaded'){return callback&&callback();}
if(script.state=='preloading'){return script.onpreload.push(function(){load(script,callback);});}
script.state='loading';scriptTag(script.url,function(){script.state='loaded';if(callback){callback.call();}
each(handlers[script.name],function(fn){fn.call();});var allLoaded=true;for(var name in scripts){if(scripts[name].state!='loaded'){allLoaded=false;}}
if(allLoaded){each(handlers.ALL,function(fn){if(!fn.done){fn.call();}
fn.done=true;});}});}
function scriptTag(src,callback){var elem=doc.createElement('script');elem.type='text/'+(src.type||'javascript');elem.src=src.src||src;elem.onreadystatechange=elem.onload=function(){var state=elem.readyState;if(!callback.done&&(!state||/loaded|complete/.test(state))){callback.call();callback.done=true;}};head.appendChild(elem);}
setTimeout(function(){ready=true;each(queue,function(fn){fn.call();});},200);})(document);