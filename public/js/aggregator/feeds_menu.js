var SMF = SMF || {};

SMF.FeedsMenu = function() {
  this.$el = $('#feeds');
  this.$links = $('a', this.$el);
};

SMF.FeedsMenu.prototype = {
  initFeeds: function(slugs) {
    var self = this;
    this.allFeeds = [];

    this.$links.each(function() {
      var feed = new SMF.Feed($(this));
      feed.isSelected = _(slugs).contains(feed.slug);

      self.allFeeds.push(feed);
    });

    this.refreshLinks();
  },

  feedWithSlug: function(slug) {
    return _(this.allFeeds).find(function(feed) {
      return feed.slug == slug;
    });
  },

  selectedFeeds: function() {
    return _(this.allFeeds).filter(function(feed) {
      return feed.isSelected;
    });
  },

  selectFeedsWithSlugs: function(slugs) {
    _(this.allFeeds).each(function(feed) {
      var isSelected = _(slugs).contains(feed.slug);
      feed.isSelected = isSelected;
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
