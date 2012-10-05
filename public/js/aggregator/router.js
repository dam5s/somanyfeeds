var SMF = SMF || {};

SMF.Router = function() {
  this.service = new SMF.Service();

  this.initializeFeedsAndMenu();
  this.articlesView = new SMF.ArticlesView();

  this.fetchArticlesForSelectedFeeds();
};

SMF.Router.prototype = {
  initializeFeedsAndMenu: function() {
    var self = this;
    var path = _(document.location.href.split('/')).last();
    var slugs = path.split('+');

    this.menuView = new SMF.MenuView(this.allFeeds);
    this.menuView.initFeeds(slugs);
  },

  fetchArticlesForSelectedFeeds: function() {
    var self = this;
    var feeds = this.menuView.selectedFeeds();

    this.service.fetchArticlesForFeeds(feeds, function(articles) {
      self.articlesView.articles = articles;
      self.articlesView.render();
    });
  }
};

