// from http://stackoverflow.com/questions/2170439/how-to-embed-javascript-widget-that-depends-on-jquery-into-an-unknown-environmen

(function(window, document, version, callback) {
    var j, d;
    var loaded = false;
    if (!(j = window.jQuery) || version > j.fn.jquery || callback(j, loaded)) {
        var script = document.createElement("script");
        script.type = "text/javascript";
        script.src = "http://code.jquery.com/jquery-1.9.1.min.js";
        script.onload = script.onreadystatechange = function() {
            if (!loaded && (!(d = this.readyState) || d == "loaded" || d == "complete")) {
                callback((j = window.jQuery).noConflict(1), loaded = true);
                j(script).remove();
            }
        };
        document.documentElement.childNodes[0].appendChild(script)
    }
})(window, document, "1.9", function($, jquery_loaded) {
  $(function () {
    $('head').append($('<link rel="stylesheet" type="text/css" />').attr('href', '//localhost:3000/widgets.css'));

    function templateEvent(event) {
      return '<p><a class="hoopla-event-name" href="' + event.url + '">' + event.name + '</a> on <span class="hoopla-event-date">' + event.start_date.substring(0, 10) + '</span></p>';
    }
  
    $('.hoopla-events').each(function (i, e) {
      var $e = $(e),
        id = $e.data('hoopla-category-ids')[0],
        limit = $e.data('hoopla-event-limit'),
        path = '/events.json?callback=?';
  
      var $loading = $e.prepend('<div class="hoopla-loading">Loading...</div>').find('.hoopla-loading');
  
      $.getJSON(path, { 'event_categories[]': id }).
        done(function (data) {
          $loading.remove();
  
          $(data).each(function (i, event) { 
            if (i < limit) {
              $e.prepend(templateEvent(event));
            }
          });
        });
    });
  });
});
