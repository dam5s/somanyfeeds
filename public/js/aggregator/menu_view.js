var SMF = SMF || {};

SMF.MenuView = function(feeds) {
  this.$el = $('#feeds');
  this.feeds = feeds;

  this.allFeeds = [];
  this.$links = $('a', this.$el);
};

SMF.MenuView.prototype = {
  initFeeds: function(slugs) {
    var self = this;

    this.$links.each(function() {
      var feed = new SMF.Feed($(this));
      feed.isSelected = _(slugs).contains(feed.slug);

      self.allFeeds.push(feed);
    });

    this.refreshLinks();
  },

  selectedFeeds: function() {
    return _(this.allFeeds).filter(function(feed) {
      return feed.isSelected;
    });
  },

  refreshLinks: function() {
    var self = this;

    _(this.allFeeds).each(function(feed) {
      self.refreshHref(feed);
      self.refreshSelectedState(feed);
    });
  },

  refreshHref: function(feed) {
    var feedsForHref;
    var feedsForHref = this.selectedFeeds();

    if (feed.isSelected) {
      feedsForHref = _(feedsForHref).without(feed);
    }
    else {
      feedsForHref.push(feed);
    }

    var newHref = _(feedsForHref).pluck('slug').sort().join('+');
    feed.$link.attr('href', '/'+newHref);
  },

  refreshSelectedState: function(feed) {
    feed.isSelected ? feed.$link.addClass('selected') : feed.$link.removeClass('selected');
  }
};
