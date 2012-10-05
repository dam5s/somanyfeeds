var SMF = SMF || {};

SMF.Service = function() {
};

SMF.Service.prototype = {
  fetchArticlesForFeeds: function(feeds, callback) {
    var path = '/' + _(feeds).pluck('slug').join('+') + '.json';

    $.get(path, function(articlesJSON) {
      var articles = _(articlesJSON).map(function(articleJSON) {
        var article = new SMF.Article();

        article.feed_name = articleJSON.feed_name;
        article.type = articleJSON.type;
        article.title = articleJSON.title;
        article.link = articleJSON.link;
        article.content = articleJSON.content;
        article.datetime = articleJSON.datetime;
        article.display_date = articleJSON.display_date;

        return article;
      });

      callback.call(this, articles);
    });
  }
};
