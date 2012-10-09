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

    this.menuView = new SMF.MenuView();
    this.menuView.initFeeds(slugs);

    _(this.menuView.allFeeds).each(function(feed) {
      feed.$link.click(function(e) {
        e.preventDefault();
        feed.isSelected = !feed.isSelected;

        self.fetchArticlesForSelectedFeeds();
        self.menuView.refreshLinks();
      });
    });
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

