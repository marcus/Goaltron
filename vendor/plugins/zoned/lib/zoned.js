var Timezone = {
  set : function() {
    var date = new Date();
    date.setTime(date.getTime() + (1000*24*60*60*1000));
    var expires = "; expires=" + date.toGMTString();
    document.cookie = "timezone=" + (-date.getTimezoneOffset() * 60) + expires + "; path=/";
  }
}
