var SMF = SMF || {};

SMF.Router = function(slugs) {
  this.service = new SMF.Service();

  this.initializeFeedsAndMenu(slugs);
  this.articlesView = new SMF.ArticlesView();

  this.fetchArticlesForSelectedFeeds();
};

SMF.Router.prototype = {
  initializeFeedsAndMenu: function(slugs) {
    var self = this;
    var path = _(document.location.href.split('/')).last();

    this.feedsMenu = new SMF.FeedsMenu();
    this.feedsMenu.initFeeds(slugs);

    _(this.feedsMenu.allFeeds).each(function(feed) {
      feed.$link.click(function(e) {
        e.preventDefault();
        self.pushFeed(feed);
        self.refreshFeeds();
      });
    });

    window.onpopstate = function(event) {
      self.popFeed(event);
    };
  },

  refreshFeeds: function() {
    this.fetchArticlesForSelectedFeeds();
    this.feedsMenu.refreshLinks();
  },

  pushFeed: function(feed) {
    feed.isSelected = !feed.isSelected;
    history.pushState({}, document.title, feed.$link.attr('href'));
  },

  popFeed: function(event) {
    if (event.state) {
      var path = _(document.location.href.split('/')).last();
      var slugs = path.split('+');

      this.feedsMenu.selectFeedsWithSlugs(slugs)
      this.refreshFeeds();
    }
  },

  fetchArticlesForSelectedFeeds: function() {
    var self = this;
    var feeds = this.feedsMenu.selectedFeeds();

    this.service.fetchArticlesForFeeds(feeds, function(articles) {
      self.articlesView.articles = articles;
      self.articlesView.render();
    });
  }
};

