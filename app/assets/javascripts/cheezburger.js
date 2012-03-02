$(function() {
  function randomIntBetween(lower, higher) {
    return parseInt(rand_no = Math.floor((higher - (lower - 1)) * Math.random()) + lower);
  }

  /*
    Unfortunately many posts on failblog.org and demotivational.com are
    not work-friendly, so add them into the list below at your own risk :)

    "http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20html%20WHERE%20url%3D%22http%3A%2F%2Ffailblog.org%2F%3Frandom%22%20AND%20xpath%3D'%2F%2Fdiv%5B%40class%3D%22snap_preview%22%5D%2F%2Fimg'&format=json&diagnostics=true&callback=?"
    "http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20html%20WHERE%20url%3D%22http%3A%2F%2Fverydemotivational.com%2F%3Frandom%22%20AND%0Axpath%3D'%2F%2Fdiv%5B%40class%3D%22snap_preview%22%5D%2F%2Fimg'&format=json&diagnostics=true&callback=?"
  */
  var cheezburger_scrape_urls = [
    "http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20html%20WHERE%20url%3D%22http%3A%2F%2Fengrishfunny.com%2F%3Frandom%22%20AND%0Axpath%3D'%2F%2Fdiv%5B%40class%3D%22snap_preview%22%5D%2F%2Fimg'&format=json&diagnostics=true&callback=?",
    "http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20html%20WHERE%20url%3D%22http%3A%2F%2Ffriendsofirony.com%2F%3Frandom%22%20AND%0Axpath%3D'%2F%2Fdiv%5B%40class%3D%22snap_preview%22%5D%2F%2Fimg'&format=json&diagnostics=true&callback=?",
    "http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20html%20WHERE%20url%3D%22http%3A%2F%2Fsomuchpun.com%2F%3Frandom%22%20AND%0Axpath%3D'%2F%2Fdiv%5B%40class%3D%22snap_preview%22%5D%2F%2Fimg'&format=json&diagnostics=true&callback=?",
    "http://query.yahooapis.com/v1/public/yql?q=SELECT%20*%20FROM%20html%20WHERE%20url%3D%22http%3A%2F%2Fthereifixedit.com%2F%3Frandom%22%20AND%0Axpath%3D'%2F%2Fdiv%5B%40class%3D%22snap_preview%22%5D%2F%2Fimg'&format=json&diagnostics=true&callback=?"
  ]

  $.ajax({
      type: 'GET',
      url: cheezburger_scrape_urls[randomIntBetween(1, cheezburger_scrape_urls.length) - 1],
      dataType: 'jsonp',
      success: function(data, textStatus) {
        $('#cheezburger-image').attr({src: ''});
        $('#cheezburger-image').attr({
            src:    data.query.results.img.src,
            width:  data.query.results.img.width,
            height: data.query.results.img.height,
            title:  data.query.results.img.title,
            alt:    data.query.results.img.alt
          });

        $('#cheezburger-image').css({'left': 0, 'top': 0});
        $('#cheezburger-image').scale('center');
        $('#cheezburger-anchor').attr('href', data.query.diagnostics.redirect.content);
        }
  });
});
