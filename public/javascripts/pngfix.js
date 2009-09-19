
var arVersion = navigator.appVersion.split("MSIE");
var version = parseFloat(arVersion[1]);

if ((version >= 5.5) && (document.body.filters)) {	
  var i;
  var length = document.images.length;
    for(i = 0; i < length; i++) {
      var img = document.images[i];
      var re = /\w+\.[Pp][Nn][Gg]\w*/;
      if (img && re.exec(img.src)) {
        var imgTitle = img.title ? "title='" + img.title + "' " : "title='" + img.alt + "' ";
	imgStyle = img.parentElement.href ? "cursor:pointer;" : "";
	imgStyle += "width:" + img.width + "px; height:" + img.height + "px;";
	imgStyle += "filter:progid:DXImageTransform.Microsoft.AlphaImageLoader (src=\'" + img.src + "\', sizingMethod='scale');";
		
	var strNewHTML = "<span " + imgTitle + " style=\"display:inline-block; " + imgStyle + " \">";

	img.outerHTML = strNewHTML;
	i = i - 1;
    }
  }
}