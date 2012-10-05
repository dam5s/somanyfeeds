var SMF = SMF || {};

SMF.Feed = function($link) {
  this.$link = $link;
  this.slug = $link.data('slug');
  this.name = $link.html().trim();
  this.isSelected = false;
};

SMF.Feed.prototype = {
};

